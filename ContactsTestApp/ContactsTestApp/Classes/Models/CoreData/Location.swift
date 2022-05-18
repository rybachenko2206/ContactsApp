//
//  Location.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 17.05.2022.
//

import Foundation
import CoreData

extension Location {
    class func getObject(city: String?, country: String?, state: String?, context: NSManagedObjectContext) -> Location {
        let fetchRequest = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "city = %@ AND country = %@ AND state = %@", city ?? "", country ?? "", state ?? "")
        
        do {
            let res = try fetchRequest.execute() as [Location]
            if let obj = res.first {
                return obj
            }
        } catch {
            pl("Picture fetch error: \n\(error)")
        }
        
        return createObject(city: city, country: country, state: state, context: context)
    }
    
    private class func createObject(city: String?, country: String?, state: String?, context: NSManagedObjectContext) -> Location {
        let entityDescr = Location.entity()
        
        let newObject = Location(entity: entityDescr, insertInto: context)
        newObject.city = city ?? ""
        newObject.country = country ?? ""
        newObject.state = state ?? ""
        
        return newObject
    }
}
