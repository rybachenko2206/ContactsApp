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
        
        self.title = viewModel?.title
        
        setupTableView()
        bindViewModel()
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
        tableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel?.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            })
            .store(in: &subscriptions)

        viewModel?.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                AlertManager.showAlert(with: error, to: self)
            })
            .store(in: &subscriptions)
    
        viewModel?.snapshotPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] snapshot in
                self?.diffableDataSource.apply(snapshot)
            })
            .store(in: &subscriptions)
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
    
    private func showContactDetails(with viewModel: PContactDetailsVM) {
        let contactDetailsVC = ContactDetailsVC.instantiate()
        contactDetailsVC.viewModel = viewModel
        navigationController?.pushViewController(contactDetailsVC, animated: true)
    }
    
    // MARK: Actions
    @IBAction private func refreshButtonTapped(_ sender: UIBarButtonItem) {
        viewModel?.getContactsFromServer()
    }
    
}

extension ContactsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ContactCell,
              let detailsVm = cell.viewModel?.detailsViewModel()
        else { return }
        
        showContactDetails(with: detailsVm)
    }
}
