//
//  DateOfBirth.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 17.05.2022.
//

import Foundation
import CoreData

extension DateOfBirth {
    class func getObject(bDateStr: String?, age: Int16?, context: NSManagedObjectContext) throws -> DateOfBirth {
        guard let bDateStr = bDateStr, let age = age else { throw AppError.custom("required fields are empty") }
        
        let fetchRequest = DateOfBirth.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date = %@ AND age = %d", bDateStr, age)
        
        do {
            let results = try fetchRequest.execute()
            if let obj = results.first {
                return obj
            } else {
                throw AppError.custom("objectNotFound")
            }
        } catch  {
            pl(error.localizedDescription)
        }
        
        return try createObject(bDateStr: bDateStr, age: age, context: context)
    }
    
    private class func createObject(bDateStr: String, age: Int16, context: NSManagedObjectContext) throws -> DateOfBirth {
        let entityDescr = DateOfBirth.entity()
        
        let newObject = DateOfBirth(entity: entityDescr, insertInto: context)
        newObject.date = bDateStr
        newObject.age = age
        
        return newObject
    }
}
