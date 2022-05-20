//
//  ContactDetailsVC.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 19.05.2022.
//

import Foundation
import UIKit

class ContactDetailsVC: UIViewController, Storyboardable {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    static var storyboardName: Storyboard { .main }
    
    var viewModel: PContactDetailsVM?
    
    // MARK: - Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Private funcs
    @objc private func editButtonTapped(_ sender: UIBarButtonItem) {
        pf()
    }
    
    private func setupView() {
        setupTableView()
        
        let editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped(_:)))
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    private func setupTableView() {
//        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = .init(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        if let headerVm = viewModel?.headerViewModel() {
            let frame = CGRect(origin: .zero, size: ContactDetailsHeaderView.defaultSize)
            let headerView = ContactDetailsHeaderView(frame: frame)
            headerView.setup(with: headerVm)
            tableView.tableHeaderView = headerView
        }
        
    }
}
