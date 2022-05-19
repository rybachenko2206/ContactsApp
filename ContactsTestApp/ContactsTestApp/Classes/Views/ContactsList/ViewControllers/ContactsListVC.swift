//
//  ViewController.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//

import UIKit
import Combine

class ContactsListVC: UIViewController, Storyboardable {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var subscriptions: Set<AnyCancellable> = []
    
    static var storyboardName: Storyboard { Storyboard.main }
    
    var viewModel: PContactsListViewModel?
    private lazy var diffableDataSource = setupDataSource()

    
    // MARK: - Override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Contacts"
        
        setupTableView()
//        bindViewModel()
        setupCompletions()
        viewModel?.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


    // MARK: - Private funcs
    private func setupTableView() {
        tableView.estimatedRowHeight = ContactCell.height()
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.registerCell(ContactCell.self)
        
        tableView.dataSource = diffableDataSource
    }
    
//    private func bindViewModel() {
//        viewModel?.isLoadingPublisher
//            .subscribe(on: DispatchQueue.main)
//            .sink(receiveValue: { [weak self] isLoading in
//                if isLoading {
//                    self?.activityIndicator.startAnimating()
//                } else {
//                    self?.activityIndicator.stopAnimating()
//                }
//            })
//            .store(in: &subscriptions)
//
//        viewModel?.errorPublisher
//            .subscribe(on: DispatchQueue.main)
//            .sink(receiveValue: { [weak self] error in
//                AlertManager.showAlert(with: error, to: self)
//            })
//            .store(in: &subscriptions)
//
//        viewModel?.reloadPublisher
//            .subscribe(on: DispatchQueue.main)
//            .sink(receiveValue: { [weak self] in
//                self?.tableView.reloadData()
//            })
//            .store(in: &subscriptions)
//    }
    
    private func setupCompletions() {
        viewModel?.isLoading = { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel?.errorCompletion = { [weak self] error in
            AlertManager.showAlert(with: error, to: self)
        }
        
        viewModel?.snapshotCompletion = { [weak self] snapshot in
            self?.diffableDataSource.apply(snapshot)
        }
    }
    
    private func setupDataSource() -> ContactsListDiffableDataSource {
        let dataSource = ContactsListDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, cellViewModel in
                let cell = tableView.dequeueReusableCell(cellType: ContactCell.self)
                cell?.setup(with: cellViewModel)
                
                return cell
            })
        
        return dataSource
    }

}
