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
    private let name: Name
    private let picture: Picture
    
    var firstName: String? { name.first }
    var lastName: String? { name.last }
    
    var placeholderImage: UIImage? { UIImage(named: "person.circle.fill") }
    var avatarImageUrl: URL? {
        guard let thumbnail = picture.thumbnail else { return nil }
        return URL(string: thumbnail)
    }
    
    // MARK: - Init
    init(name: Name, picture: Picture) {
        self.name = name
        self.picture = picture
    }
}
