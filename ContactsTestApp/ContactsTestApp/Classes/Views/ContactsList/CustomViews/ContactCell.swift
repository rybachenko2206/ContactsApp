//
//  ContactCell.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 17.05.2022.
//

import UIKit
import SDWebImage

class ContactCell: UITableViewCell, ReusableCell {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var firstNameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        avatarImageView.layer.masksToBounds = true
    }

    
    static func height() -> CGFloat {
        return 62
    }
    
    func setup(with viewModel: ContactCellViewModel) {
        avatarImageView.sd_setImage(with: viewModel.avatarImageUrl, placeholderImage: viewModel.placeholderImage)
        firstNameLabel.text = viewModel.firstName
        lastNameLabel.text = viewModel.lastName
    }
    
}
