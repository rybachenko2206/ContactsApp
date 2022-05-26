//
//  NSManagedObjectContext.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 25.05.2022.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    var isInserted: Bool {
        return self.insertedObjects.count > 0
    }
    
    var isUpdated: Bool {
        return self.updatedObjects.count > 0
    }
}
