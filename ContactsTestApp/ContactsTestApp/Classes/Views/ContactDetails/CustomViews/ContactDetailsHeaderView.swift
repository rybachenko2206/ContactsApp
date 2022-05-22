//
//  ContactDetailsHeaderView.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 19.05.2022.
//

import UIKit
import SDWebImage

class ContactDetailsHeaderView: UIView, NibMakableProtocol {
    // MARK: - Outlets
    @IBOutlet private var view: UIView!
    @IBOutlet weak var avatarImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var smsButton: UIButton?
    @IBOutlet weak var callButton: UIButton?
    @IBOutlet weak var emailButton: UIButton?
    
    // MARK: - Properties
    var contentView: UIView? { return view }
    
    static var defaultSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 257)
    }
    
    private var viewModel: PContactDetailsHeaderVM?
    
    // MARK: - Init funcs
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    // MARK: - Public funcs
    func setupUI() {
        avatarImageView?.setCornerRadius(50)
        smsButton?.setCornerRadius(6)
        callButton?.setCornerRadius(6)
        emailButton?.setCornerRadius(6)
    }
    
    func setup(with viewModel: PContactDetailsHeaderVM) {
        self.viewModel = viewModel
        avatarImageView?.sd_setImage(with: viewModel.avatarUrl, placeholderImage: viewModel.placeholderImage)
        nameLabel?.text = viewModel.name
        smsButton?.isEnabled = viewModel.smsButtonEnabled
        callButton?.isEnabled = viewModel.callButtonEnabled
        emailButton?.isEnabled = viewModel.emailButtonEnabled
    }
    
    // MARK: - Private funcs
    @IBAction private func smsButtonTapped(_ sender: Any) {
        viewModel?.handleSmsAction()
    }
    
    @IBAction private func callButtonTapped(_ sender: Any) {
        viewModel?.handleCallAction()
    }
    
    @IBAction private func letterButtonTapped(_ sender: Any) {
        viewModel?.handleLetterAction()
    }
    
}
