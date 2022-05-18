//
//  Picture+CoreDataClass.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//
//

import Foundation
import CoreData


public class Picture: NSManagedObject, Decodable, ManagedObjectType {
    static let entityName: String = "Picture"
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            throw AppError.mocInDecodable
        }
        
        guard let entityDescr = NSEntityDescription.entity(forEntityName: Picture.entityName, in: context) else {
            throw AppError.custom("Can not create EntityDescription")
        }
        
        self.init(entity: entityDescr, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        large = try? container.decode(String.self, forKey: .large)
        medium = try? container.decode(String.self, forKey: .medium)
        thumbnail = try? container.decode(String.self, forKey: .thumbnail)
    }
    
    enum CodingKeys: String, CodingKey {
        case large, medium, thumbnail
    }
}
