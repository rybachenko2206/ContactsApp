//
//  Utils.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//

import Foundation
import CoreTelephony
import UIKit

class Utils {
//    static let jsonDecoder: JSONDecoder = {
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        // TODO: Clarify and fix set .dateDecodingStrategy and change type for date property from String to Date
////        decoder.dateDecodingStrategy = .formatted(dateFormatter)
//        return decoder
//    }()
    
    static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
    // link to article https://sarunw.com/posts/how-to-parse-iso8601-date-in-swift/
//        formatter.formatOptions = [
//            .withInternetDateTime,
//            .withFractionalSeconds
//        ]
        return formatter
    }()
    
    static let appDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let url = urls.first else {
            fatalError("Can not get url to Documents directory")
        }
        return url
    }()
    
    final class func isPhoneNumberValid(_ phoneNumber: String?) -> Bool {
        // TODO: maybe add phone number validation
        guard let phone = phoneNumber, !phone.isEmpty else { return false }
        return true
    }
    
    final class func canMakePhoneCall() -> Bool {
        guard let url = URL(string: "tel://") else {
            return false
        }

        return UIApplication.shared.canOpenURL(url)
        
        // TODO: mobileNetworkCode check
//        let mobileNetworkCode = CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode
//
//        let isInvalidNetworkCode = mobileNetworkCode == nil
//            || mobileNetworkCode?.count == 0
//            || mobileNetworkCode == "65535"
//
//        return UIApplication.shared.canOpenURL(url) && !isInvalidNetworkCode
    }
}
