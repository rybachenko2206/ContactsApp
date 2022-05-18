//
//  Location+CoreDataClass.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//
//

import Foundation
import CoreData


public class Location: NSManagedObject, Decodable, ManagedObjectType {
    static let entityName: String = "Location"
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            throw AppError.mocInDecodable
        }
        guard let entityDescr = NSEntityDescription.entity(forEntityName: Location.entityName, in: context) else {
            throw AppError.custom("Can not create EntityDescription")
        }
        self.init(entity: entityDescr, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        city = try? container.decode(String.self, forKey: .city)
        country = try? container.decode(String.self, forKey: .country)
        state = try? container.decode(String.self, forKey: .state)
    }
    
    enum CodingKeys: String, CodingKey {
        case city, country, state
    }
}
