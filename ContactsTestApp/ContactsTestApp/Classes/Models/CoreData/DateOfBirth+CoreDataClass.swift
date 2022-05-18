//
//  DateOfBirth+CoreDataClass.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//
//

import Foundation
import CoreData

public class DateOfBirth: NSManagedObject, Decodable, ManagedObjectType {
    static let entityName: String = "DateOfBirth"
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            throw AppError.mocInDecodable
        }
        
        guard let entityDescr = NSEntityDescription.entity(forEntityName: DateOfBirth.entityName, in: context) else {
            throw AppError.custom("Can not create EntityDescription")
        }
        
        self.init(entity: entityDescr, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try? container.decode(String.self, forKey: .date)
        
        let ageValue = try? container.decode(Int16.self, forKey: .age)
        age = ageValue ?? 0
    }
    
    enum CodingKeys: String, CodingKey {
        case date, age
    }
}
