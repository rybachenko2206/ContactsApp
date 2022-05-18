//
//  Contact+CoreDataProperties.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 17.05.2022.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var email: String?
    @NSManaged public var gender: String?
    @NSManaged public var dob: DateOfBirth?
    @NSManaged public var location: Location?
    @NSManaged public var name: Name?
    @NSManaged public var picture: Picture?

}

extension Contact : Identifiable {

}
