//
//  ContactsListViewModel.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//

import Foundation
import Combine
import CoreData

protocol PContactsListViewModel/*: DataLoadable*/ {
//    var reloadPublisher: AnyPublisher<Void, Never> { get }
//    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
//    var errorPublisher: AnyPublisher<AppError, Never>
    
    func start()
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func contactItem(for indexPath: IndexPath) -> ContactCellViewModel?
}

class ContactsListViewModel: PContactsListViewModel {
    // MARK: - Properties
    private let coreDataStack: CoreDataStack
    private let networkService: PNetworkService
    
    private var contactsViewModels: [ContactCellViewModel] = []
    private var contacts: [Contact] = []
    
    @Published private var isLoading: Bool = false
    @Published private var error: AppError?
    
    private let reloadTable = PassthroughSubject<Void, Never>()
    
//    var reloadPublisher: AnyPublisher<Void, Never> {
//        reloadPublisher.eraseToAnyPublisher()
//    }
//
//    var isLoadingPublisher: AnyPublisher<Bool, Never> {
//        $isLoading.eraseToAnyPublisher()
//    }
//    var errorPublisher: AnyPublisher<AppError, Never> {
//        $error
//            .compactMap({ $0 })
//            .eraseToAnyPublisher()
//    }
    
    // MARK: - Init
    init(coreDataStack: CoreDataStack, networkService: PNetworkService) {
        self.coreDataStack = coreDataStack
        self.networkService = networkService
    }
    
    // MARK: - Public funcs
    func start() {
        fetchLocalContacts(completion: { [weak self] result in
            if result.count > 0 {
                self?.contacts = result
                self?.isLoading = false
                self?.reloadTable.send(())
            }  else {
                self?.getContactsFromServer()
            }
        })
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return contactsViewModels.count
    }
    
    func contactItem(for indexPath: IndexPath) -> ContactCellViewModel? {
        return contactsViewModels[safe: indexPath.row]
    }
    
    // MARK: - Private funcs
    private func saveReceivedContacts(_ contacts: [Contact]) {
        guard contacts.count > 0,
              let context = contacts.first?.managedObjectContext
        else { return }
        
        coreDataStack.saveContext(context: context)
    }
    
    private func getContactsFromServer() {
        isLoading = true
        networkService.getContacts(completion: { [weak self] result in
            switch result {
            case .success(let response):
                self?.saveReceivedContacts(response.results)
                self?.reloadTable.send(())
            case .failure(let error):
                self?.error = error
            }
            self?.isLoading = false
        })
    }
    
    private func fetchLocalContacts(completion: @escaping ([Contact]) -> Void) {
        isLoading = true
        coreDataStack.mainContext.perform({
            let fetchRequest = Contact.fetchRequest()
            let lastNameSortDescr = NSSortDescriptor(key: "name.last", ascending: true)
            let firstNameSortDescr = NSSortDescriptor(key: "name.first", ascending: true)
            fetchRequest.sortDescriptors = [lastNameSortDescr, firstNameSortDescr]
            
            do {
                let results = try fetchRequest.execute()
                completion(results)
            } catch {
                pl("Problem with executing persons error \n\(error)")
            }
        })
        
    }
}
