//
//  ContactsListViewModel.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//

import Foundation
import Combine
import CoreData

typealias Completion = () -> Void
typealias BoolCompletion = (Bool) -> Void
typealias ErrorCompletion = (AppError) -> Void

protocol PContactsListViewModel/*: DataLoadable*/ {
//    var reloadPublisher: AnyPublisher<Void, Never> { get }
//    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
//    var errorPublisher: AnyPublisher<AppError, Never> { get }
    var reloadTable: Completion? { get set }
    var isLoading: BoolCompletion? { get set }
    var errorCompletion: ErrorCompletion? { get set }
    
    func start()
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func contactItem(for indexPath: IndexPath) -> ContactCellViewModel?
}

class ContactsListViewModel: PContactsListViewModel {
    // MARK: - Properties
    private let coreDataStack: CoreDataStack
    private let networkService: PNetworkService
    
    private var moContext: NSManagedObjectContext {
        return coreDataStack.mainContext
    }
    
    private var contactsViewModels: [ContactCellViewModel] = []
    
//    @Published private var isLoading: Bool = false
//    @Published private var error: AppError?
//
//    private let reloadTable = PassthroughSubject<Void, Never>()
//
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
    
    var reloadTable: Completion?
    var isLoading: BoolCompletion?
    var errorCompletion: ErrorCompletion?
    
    // MARK: - Init
    init(coreDataStack: CoreDataStack, networkService: PNetworkService) {
        self.coreDataStack = coreDataStack
        self.networkService = networkService
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contextDidChange(_:)),
                                               name: .NSManagedObjectContextObjectsDidChange,
                                               object: moContext)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public funcs
    func start() {
        isLoading?(true)
        
        fetchLocalContacts(completion: { [weak self] result in
            if result.count > 0 {
                self?.handleSuccess(with: result)
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
    
    // MARK: - Notification Observers
    @objc private func contextDidChange(_ notification: Notification) {
        fetchLocalContacts(completion: { [weak self] results in
            self?.handleSuccess(with: results)
        })
    }
    
    // MARK: - Private funcs
    private func handleSuccess(with results: [Contact]) {
        contactsViewModels = results.compactMap({ ContactCellViewModel(contact: $0) })
        DispatchQueue.main.async {
            self.isLoading?(false)
            self.reloadTable?()
        }
    }
    
    private func handleFailure(with error: AppError) {
        DispatchQueue.main.async {
            self.isLoading?(false)
            self.errorCompletion?(error)
        }
    }
    
    private func saveReceivedContacts(_ contacts: [Contact]) {
        guard contacts.count > 0,
              let context = contacts.first?.managedObjectContext
        else { return }
        
        coreDataStack.saveContext(context: context)
    }
    
    private func getContactsFromServer() {
        networkService.getContacts(completion: { [weak self] result in
            switch result {
            case .success(let response):
                self?.saveReceivedContacts(response.results)
            case .failure(let error):
                self?.handleFailure(with: error)
            }
        })
    }
    
    private func fetchLocalContacts(completion: @escaping ([Contact]) -> Void) {
        isLoading?(true)
        coreDataStack.mainContext.perform({
            let fetchRequest = Contact.fetchRequest()
            let lastNameSortDescr = NSSortDescriptor(key: "name.last", ascending: true)
            let firstNameSortDescr = NSSortDescriptor(key: "name.first", ascending: true)
            fetchRequest.sortDescriptors = [lastNameSortDescr, firstNameSortDescr]
            
            do {
                let results = try fetchRequest.execute()
                pl("local contacts count - \(results.count)")
                completion(results)
            } catch {
                pl("Problem with executing persons error \n\(error)")
            }
        })
        
    }
}