//
//  GetContactsResponse.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//

import Foundation

struct GetContactsResponse: Decodable {
    let results: [Contact]
}

