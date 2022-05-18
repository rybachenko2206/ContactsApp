//
//  JSONDecoder.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//

import Foundation
import CoreData

extension CodingUserInfoKey {
   static let context = CodingUserInfoKey(rawValue: "context")
}

extension JSONDecoder {
    convenience init?(context: NSManagedObjectContext) {
        guard let contextUserInfoKey = CodingUserInfoKey.context else { return nil }
        
        self.init()
        self.userInfo[contextUserInfoKey] = context
    }
}


