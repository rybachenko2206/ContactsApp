//
//  Picture+CoreDataProperties.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 17.05.2022.
//
//

import Foundation
import CoreData


extension Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture")
    }

    @NSManaged public var large: String?
    @NSManaged public var medium: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var contact: NSSet?

}

// MARK: Generated accessors for contact
extension Picture {

    @objc(addContactObject:)
    @NSManaged public func addToContact(_ value: Contact)

    @objc(removeContactObject:)
    @NSManaged public func removeFromContact(_ value: Contact)

    @objc(addContact:)
    @NSManaged public func addToContact(_ values: NSSet)

    @objc(removeContact:)
    @NSManaged public func removeFromContact(_ values: NSSet)

}

extension Picture : Identifiable {

}
