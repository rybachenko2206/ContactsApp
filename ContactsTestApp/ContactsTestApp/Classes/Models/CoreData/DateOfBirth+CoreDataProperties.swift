//
//  DateOfBirth+CoreDataProperties.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 17.05.2022.
//
//

import Foundation
import CoreData


extension DateOfBirth {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DateOfBirth> {
        return NSFetchRequest<DateOfBirth>(entityName: "DateOfBirth")
    }

    @NSManaged public var age: Int16
    @NSManaged public var date: String?
    @NSManaged public var contact: NSSet?

}

// MARK: Generated accessors for contact
extension DateOfBirth {

    @objc(addContactObject:)
    @NSManaged public func addToContact(_ value: Contact)

    @objc(removeContactObject:)
    @NSManaged public func removeFromContact(_ value: Contact)

    @objc(addContact:)
    @NSManaged public func addToContact(_ values: NSSet)

    @objc(removeContact:)
    @NSManaged public func removeFromContact(_ values: NSSet)

}

extension DateOfBirth : Identifiable {

}
