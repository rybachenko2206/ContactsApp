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

    
    // MARK: - Override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Contacts"
        
        setupTableView()
        bindViewModel()
//        viewModel?.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


    // MARK: - Private funcs
    private func setupTableView() {
        tableView.estimatedRowHeight = ContactCell.height()
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.registerCell(ContactCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bindViewModel() {
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
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ContactsListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellVm = viewModel?.contactItem(for: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ContactCell.self)
        
        cell.setup(with: cellVm)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Open contact details
    }
}

