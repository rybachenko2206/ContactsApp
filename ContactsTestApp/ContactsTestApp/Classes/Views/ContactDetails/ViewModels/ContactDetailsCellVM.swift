//
//  ContactDetailsCellVM.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 22.05.2022.
//

import Foundation

struct ContactDetailsCellVM: Equatable, Hashable {
    let title: String
    let value: String
    
    init?(title: String, value: String?) {
        guard let val = value, !val.isEmpty else { return nil }
        self.title = title
        self.value = val
    }
}
