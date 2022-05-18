//
//  Picture.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 17.05.2022.
//

import Foundation
import CoreData

extension Picture {
    class func getObject(thumbnail: String, medium: String, large: String, context: NSManagedObjectContext) -> Picture {
        let fetchRequest = Picture.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "thumbnail = %@ AND medium = %@ AND large = %@", thumbnail, medium, large)
        
        do {
            let res = try fetchRequest.execute() as [Picture]
            if let obj = res.first {
                return obj
            }
        } catch {
            pl("Picture fetch error: \n\(error)")
        }
        
        return createObject(thumbnail: thumbnail, medium: medium, large: large, context: context)
    }
    
    private class func createObject(thumbnail: String, medium: String, large: String, context: NSManagedObjectContext) -> Picture {
        let entityDescr = Picture.entity()
        
        let newObject = Picture(entity: entityDescr, insertInto: context)
        newObject.thumbnail = thumbnail
        newObject.medium = medium
        newObject.large = large
        
        return newObject
    }
}
