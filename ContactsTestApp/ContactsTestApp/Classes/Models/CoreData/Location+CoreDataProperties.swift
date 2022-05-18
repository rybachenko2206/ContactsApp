//
//  Location+CoreDataProperties.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 17.05.2022.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var state: String?
    @NSManaged public var contact: NSSet?

}

// MARK: Generated accessors for contact
extension Location {

    @objc(addContactObject:)
    @NSManaged public func addToContact(_ value: Contact)

    @objc(removeContactObject:)
    @NSManaged public func removeFromContact(_ value: Contact)

    @objc(addContact:)
    @NSManaged public func addToContact(_ values: NSSet)

    @objc(removeContact:)
    @NSManaged public func removeFromContact(_ values: NSSet)

}

extension Location : Identifiable {

}
