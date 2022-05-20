//
//  UIView.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 19.05.2022.
//

import Foundation
import UIKit

extension UIView {
    func setCornerRadius(_ radius: CGFloat, maskToBounds: Bool = true) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = maskToBounds
    }
}
