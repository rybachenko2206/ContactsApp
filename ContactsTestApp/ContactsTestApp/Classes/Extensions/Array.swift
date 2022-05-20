//
//  Array.swift
//  BeersTestApp
//
//  Created by Roman Rybachenko on 24.01.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//


import Foundation


extension Array {
    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
    
    func item(at index: Int) -> Element? {
      return indices.contains(index) ? self[index] : nil
    }
    
}

extension Array where Element == String? {
    /// For Array of optional strings will combine all values with " " as separator. Will return nil if all elements is nill or array is empty or all items is empty strings
    var spaceJoined: String? {
        return joinedBy()
    }
    
    func joinedBy(_ separator: String = " ") -> String? {
        let noNilArray = compactMap { $0 }.filter { !$0.isEmpty }
        if noNilArray.isEmpty { return nil }
        return noNilArray.joined(separator: separator)
    }
}

extension Array where Element == String {
    var spaceJoined: String { joined(separator: " ") }
}
