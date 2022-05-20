//
//  ContactDetailsVM.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 19.05.2022.
//

import Foundation

protocol PContactDetailsVM {
    var title: String? { get }
    
    func headerViewModel() -> PContactDetailsHeaderVM
}

class ContactDetailsVM: PContactDetailsVM {
    var title: String? { nil }
    
    private let contact: Contact
    
    // MARK: - Init
    init(with contact: Contact) {
        self.contact =  contact
    }
    
    func headerViewModel() -> PContactDetailsHeaderVM {
        return ContactDetailsHeaderVM(name: contact.name,
                                      picture: contact.picture,
                                      phone: contact.homePhone,
                                      email: contact.email)
    }
}
