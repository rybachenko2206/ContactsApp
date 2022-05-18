//
//  ContactCellViewModel.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 17.05.2022.
//

import Foundation
import UIKit

class ContactCellViewModel {
    // MARK: - Properties
    let contact: Contact
    
    var firstName: String? { contact.name?.first }
    var lastName: String? { contact.name?.last }
    
    var placeholderImage: UIImage? {
        UIImage(systemName: "person.circle.fill")?
            .withRenderingMode(.alwaysTemplate)
    }
    var avatarImageUrl: URL? {
        guard let thumbnail = contact.picture?.thumbnail else { return nil }
        return URL(string: thumbnail)
    }
    
    // MARK: - Init
    init(contact: Contact) {
        self.contact = contact
    }
}
