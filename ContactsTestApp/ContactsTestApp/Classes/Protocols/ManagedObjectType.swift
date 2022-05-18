//
//  ManagedObjectType.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//

import Foundation
import CoreData

protocol ManagedObjectType {
    static var entityName: String { get }
    
}

extension ManagedObjectType {
    public static func fetchRequest(predicateFormat: String,
                                    arguments: [Any],
                                    sortDescriptors: [NSSortDescriptor]?) -> NSFetchRequest<NSFetchRequestResult> {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.sortDescriptors = sortDescriptors
        
        let predicate = NSPredicate(format: predicateFormat, argumentArray: arguments)
        request.predicate = predicate
        
        return request
    }
}
