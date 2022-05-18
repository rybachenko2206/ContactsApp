//
//  Name.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 17.05.2022.
//

import Foundation
import CoreData

extension Name {
    class func getName(with firstName: String, lastName: String, title: String, context: NSManagedObjectContext) -> Name {
        let fetchRequest = Name.fetchRequest()
        let predicate = NSPredicate(format: "#first = %@ AND #last = %@ AND title = %@", firstName, lastName, title)
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest) as [Name]

            if let object = results.first {
                return object
            }
        } catch {
            pl(error.localizedDescription)
        }

        return createObject(with: firstName, lastName: lastName, title: title, context: context)
    }
    
    private class func createObject(with firstName: String, lastName: String, title: String, context: NSManagedObjectContext) -> Name {
        let entityDescr = Name.entity()
        let newObj = Name(entity: entityDescr, insertInto: context)
        newObj.title = title
        newObj.first = firstName
        newObj.last = lastName
        
        return newObj
    }
}
