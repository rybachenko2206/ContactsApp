//
//  ContactsListViewModel.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//

import Foundation
import Combine
import CoreData
import UIKit

typealias Completion = () -> Void
typealias BoolCompletion = (Bool) -> Void
typealias ErrorCompletion = (AppError) -> Void
typealias SnapshotCompletion = (NSDiffableDataSourceSnapshot<ContactsListSectionModel, ContactCellViewModel>) -> Void
typealias ContactsListSnapshot = NSDiffableDataSourceSnapshot<ContactsListSectionModel, ContactCellViewModel>

protocol PContactsListViewModel/*: DataLoadable*/ {
    var title: String { get }
    
//    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
//    var errorPublisher: AnyPublisher<AppError, Never> { get }
    var snapshotPublisher: AnyPublisher<ContactsListSnapshot, Never> { get }
    
    var isLoading: BoolCompletion? { get set }
    var errorCompletion: ErrorCompletion? { get set }
    var snapshotCompletion: SnapshotCompletion? { get set }
    
    func start()
    func deleteContact(_ contact: Contact)
}

class ContactsListViewModel: PContactsListViewModel {
    // MARK: - Properties
    private let coreDataStack: CoreDataStack
    private let networkService: PNetworkService
    
    private var moContext: NSManagedObjectContext {
        return coreDataStack.mainContext
    }
    
//    @Published private var isLoading: Bool = false
//    @Published private var error: AppError?

    @Published private var snapshot: ContactsListSnapshot = ContactsListSnapshot()

    var snapshotPublisher: AnyPublisher<ContactsListSnapshot, Never> {
        $snapshot
            .map({ $0 })
            .eraseToAnyPublisher()
    }
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
    let title = "My Contacts"
    
    var isLoading: BoolCompletion?
    var errorCompletion: ErrorCompletion?
//    var reloadTable: Completion?
    var snapshotCompletion: SnapshotCompletion?
    
    // MARK: - Init
    init(coreDataStack: CoreDataStack, networkService: PNetworkService) {
        self.coreDataStack = coreDataStack
        self.networkService = networkService
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(contextDidChange(_:)),
//                                               name: .NSManagedObjectContextObjectsDidChange,
//                                               object: moContext)
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
    
    func deleteContact(_ contact: Contact) {
        guard let context = contact.managedObjectContext else { return }
        context.delete(contact)
        coreDataStack.saveContext(context: context)
    }
    
    // MARK: - Notification Observers
    @objc private func contextDidChange(_ notification: Notification) {
//        fetchLocalContacts(completion: { [weak self] results in
//            guard let self = self, self.moContext.insertedObjects.count > 0
//            else { return }
//
//            self.handleSuccess(with: results)
//        })
    }
    
    // MARK: - Private funcs
    
    private func handleSuccess(with results: [Contact]) {
        let snapshot = makeSnapshot(with: results)
        
        DispatchQueue.main.async {
            self.isLoading?(false)
            self.snapshotCompletion?(snapshot)
        }
    }
    
    private func makeSnapshot(with contacts: [Contact]) -> ContactsListSnapshot {
        let sectionModels = makeSectionModels(with: contacts)
        
        var snapshot = self.snapshot
        
        snapshot.appendSections(sectionModels)
        for sectionModel in sectionModels {
            snapshot.appendItems(sectionModel.items, toSection: sectionModel)
        }
        
        return snapshot
    }
    
    private func makeSectionModels(with contacts: [Contact]) -> [ContactsListSectionModel] {
        let itemViewModels = contacts.compactMap({ ContactCellViewModel(contact: $0) })
        itemViewModels.forEach({
            $0.deleteClosure = { [weak self] contactCellVm in
                guard let self = self else { return }
                self.deleteContact(contactCellVm.contact)
            }
        })
        var sectionModels: [ContactsListSectionModel] = []
        
        var lettersSet = Set<String>()
        itemViewModels.forEach({
            if let letter = $0.lastName?.first {
                lettersSet.insert(String(letter))
            }
        })
        for letter in lettersSet {
            let filteredItems = itemViewModels.filter({ $0.lastName?.hasPrefix(letter) ?? false })
            let sectionModel = ContactsListSectionModel(header: letter, items: filteredItems)
            sectionModels.append(sectionModel)
        }
        
        sectionModels.sort(by: {
            $0.header < $1.header
        })
        return sectionModels
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
