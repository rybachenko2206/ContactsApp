//
//  Contact.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 17.05.2022.
//

import Foundation
import CoreData

extension Contact {
    class func getContact(email: String, gender: String?, dateOfBirth: DateOfBirth?, name: Name?, location: Location?, picture: Picture?, context: NSManagedObjectContext) -> Contact? {
        guard !email.isEmpty else { return nil }
        let fetchRequest = Contact.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email = %@", email)
        
        return createContact(email: email, gender: gender, dateOfBirth: dateOfBirth, name: name, location: location, picture: picture, context: context)
    }
    
    private class func createContact(email: String, gender: String?, dateOfBirth: DateOfBirth?, name: Name?, location: Location?, picture: Picture?, context: NSManagedObjectContext) -> Contact? {
        
        guard let entityDescr = NSEntityDescription.entity(forEntityName: Contact.entityName, in: context)
            else { return nil }
        
        let newContact = Contact(entity: entityDescr, insertInto: context)
        newContact.email = email
        newContact.gender = gender
        newContact.dob = dateOfBirth
        newContact.name = name
        newContact.location = location
        newContact.picture = picture
        
        return newContact
    }
}
