//
//  ContactDetailsCell.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 22.05.2022.
//

import UIKit

class ContactDetailsCell: UITableViewCell, ReusableCell {
    
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    func setup(with viewModel: ContactDetailsCellVM) {
        captionLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }
 
    static func height() -> CGFloat {
        60
    }
}
