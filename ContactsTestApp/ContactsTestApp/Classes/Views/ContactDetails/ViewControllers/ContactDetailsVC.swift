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
    
    private lazy var diffableDataSource = createDataSource()
    
    // MARK: - Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }

    // MARK: - Private funcs
    @objc private func editButtonTapped(_ sender: UIBarButtonItem) {
        pf()
    }
    
    private func setupTableView() {
        tableView.contentInset = .init(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        
        tableView.estimatedRowHeight = ContactDetailsCell.height()
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.registerCell(ContactDetailsCell.self)
        tableView.registerCell(ContactCell.self)
        
        if let vm = viewModel {
            let frame = CGRect(origin: .zero, size: ContactDetailsHeaderView.defaultSize)
            let headerView = ContactDetailsHeaderView(frame: frame)
            headerView.setup(with: vm.headerViewModel())
            tableView.tableHeaderView = headerView

            diffableDataSource.apply(vm.makeSnapshot())
        }

        tableView.dataSource = diffableDataSource
    }
    
    private func createDataSource() -> UITableViewDiffableDataSource<ContactDetailsSectionModel, ContactDetailsCellVM> {
        let dataSource = UITableViewDiffableDataSource<ContactDetailsSectionModel, ContactDetailsCellVM>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, cellVm in
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ContactDetailsCell.self)
                cell.setup(with: cellVm)

                return cell
            })

        return dataSource
    }
}
