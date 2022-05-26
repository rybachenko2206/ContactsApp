//
//  ContactDetailsVM.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 19.05.2022.
//

import Foundation
import UIKit

protocol PContactDetailsVM {
    var title: String? { get }

    func headerViewModel() -> PContactDetailsHeaderVM
    func makeSnapshot() -> NSDiffableDataSourceSnapshot<ContactDetailsSectionModel, ContactDetailsCellVM>
}

class ContactDetailsVM: PContactDetailsVM {
    var title: String? { nil }
    
    private let contact: Contact
    private var sectionModels: [ContactDetailsSectionModel] = []
    
    // MARK: - Init
    init(with contact: Contact) {
        self.contact =  contact
    }
    
    // MARK: - Public funcs
    func numberOfSections() -> Int {
        return sectionModels.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return sectionModels[safe: section]?.items.count ?? 0
    }
    
    func cellViewModel(for indexPath: IndexPath) -> ContactDetailsCellVM? {
        guard let sm = sectionModels[safe: indexPath.section],
              let itemVm = sm.items[safe: indexPath.row]
        else { return nil }
        
        return itemVm
    }
    
    func headerViewModel() -> PContactDetailsHeaderVM {
        return ContactDetailsHeaderVM(name: contact.name,
                                      picture: contact.picture,
                                      phone: contact.homePhone,
                                      email: contact.email)
    }
    
    func makeSnapshot() -> NSDiffableDataSourceSnapshot<ContactDetailsSectionModel, ContactDetailsCellVM> {
        var snapshot = NSDiffableDataSourceSnapshot<ContactDetailsSectionModel, ContactDetailsCellVM>()
        
        let sectionModels = makeSectionModels()
        
        snapshot.appendSections(sectionModels)
        sectionModels.forEach({
            snapshot.appendItems($0.items, toSection: $0)
        })
        
        return snapshot
    }
    
    private func makeSectionModels() -> [ContactDetailsSectionModel] {
        var sectionModels: [ContactDetailsSectionModel] = []
        
        let phoneVms = [
            ContactDetailsCellVM(title: "Home", value: contact.homePhone),
            ContactDetailsCellVM(title: "Mobile", value: contact.mobilePhone)
        ].compactMap({ $0 })
        
        if !phoneVms.isEmpty {
            sectionModels.append(ContactDetailsSectionModel(title: nil, items: phoneVms))
        }
        
        let emailVms = [ContactDetailsCellVM(title: "Email", value: contact.email)].compactMap({ $0 })
        if !emailVms.isEmpty {
            sectionModels.append(ContactDetailsSectionModel(title: nil, items: emailVms))
        }
        
        let locationStr = [contact.location?.city, contact.location?.state, contact.location?.country].joinedBy("\n")
        if let locationCellVm = ContactDetailsCellVM(title: "Location", value: locationStr) {
            sectionModels.append(ContactDetailsSectionModel(title: nil, items: [locationCellVm]))
        }
        
        return sectionModels
    }
    
}

struct ContactDetailsSectionModel: Hashable {
    let title: String?
    let items: [ContactDetailsCellVM]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(items)
    }
    
    static func == (lhs: ContactDetailsSectionModel, rhs: ContactDetailsSectionModel) -> Bool {
        return lhs.title == rhs.title && lhs.items == rhs.items
    }
}
