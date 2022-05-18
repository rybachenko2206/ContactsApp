//
//  Name+CoreDataClass.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//
//

import Foundation
import CoreData


public class Name: NSManagedObject, Decodable, ManagedObjectType {
    static let entityName: String = "Name"
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            throw AppError.mocInDecodable
        }
        
        guard let entityDescr = NSEntityDescription.entity(forEntityName: Name.entityName, in: context) else {
            throw AppError.custom("Can not create EntityDescription")
        }
        
        self.init(entity: entityDescr, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        first = try? container.decode(String.self, forKey: .first)
        last = try? container.decode(String.self, forKey: .last)
        title = try? container.decode(String.self, forKey: .title)
    }
    
    enum CodingKeys: String, CodingKey {
        case first, last, title
    }
}
