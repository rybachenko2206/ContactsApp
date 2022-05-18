//
//  Contact+CoreDataClass.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 17.05.2022.
//
//

import Foundation
import CoreData


public class Contact: NSManagedObject, Decodable, ManagedObjectType {
    static let entityName: String = "Contact"
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            throw AppError.mocInDecodable
        }
        
        guard let entityDescr = NSEntityDescription.entity(forEntityName: Contact.entityName, in: context) else {
            throw AppError.custom("Can not create EntityDescription")
        }
        self.init(entity: entityDescr, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        email = try container.decode(String.self, forKey: .email)
        homePhone = try? container.decode(String.self, forKey: .homePhone)
        mobilePhone = try? container.decode(String.self, forKey: .mobilePhone)
        gender = try? container.decode(String.self, forKey: .gender)
        dob = try? container.decode(DateOfBirth.self, forKey: .dob)
        location = try? container.decode(Location.self, forKey: .location)
        name = try? container.decode(Name.self, forKey: .name)
        picture = try? container.decode(Picture.self, forKey: .picture)
    }
    
    enum CodingKeys: String, CodingKey {
        case email, gender, dob, location, name, picture
        case homePhone = "phone"
        case mobilePhone = "cell"
    }
}
