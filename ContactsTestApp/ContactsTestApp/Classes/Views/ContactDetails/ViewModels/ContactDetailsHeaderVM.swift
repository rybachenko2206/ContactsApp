//
//  ContactDetailsHeaderVM.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 19.05.2022.
//

import Foundation
import UIKit

protocol PContactDetailsHeaderVM {
    var name: String? { get }
    var avatarUrl: URL? { get }
    var placeholderImage: UIImage? { get }
    
    var smsButtonEnabled: Bool { get }
    var callButtonEnabled: Bool { get }
    var emailButtonEnabled: Bool { get }
    
    func handleSmsAction()
    func handleCallAction()
    func handleLetterAction()
}

class ContactDetailsHeaderVM: PContactDetailsHeaderVM {
    private let phoneNumber: String?
    private let email: String?
    let name: String?
    var avatarUrl: URL?
    let placeholderImage = UIImage(systemName: "person.circle.fill")?.withRenderingMode(.alwaysTemplate)
    
    var callButtonEnabled: Bool {
        Utils.isPhoneNumberValid(phoneNumber) && Utils.canMakePhoneCall()
    }
    
    var smsButtonEnabled: Bool {
        Utils.isPhoneNumberValid(phoneNumber)
    }
    
    var emailButtonEnabled: Bool {
        // TODO: maybe add email validation
        guard let email = self.email, !email.isEmpty else { return false}
        return true
    }
    
    init(name: Name?, picture: Picture?, phone: String?, email: String?) {
        self.name = [name?.first, name?.last].spaceJoined
        self.avatarUrl = URL(string: picture?.large ?? "")
        self.phoneNumber = phone
        self.email = email
    }
    
    // MARK: - Public funcs
    func handleSmsAction() {
        pf()
    }
    
    func handleCallAction() {
        pf()
    }
    
    func handleLetterAction() {
        pf()
    }
    
}
