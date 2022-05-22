//
//  ContactsListDiffableDataSource.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 18.05.2022.
//

import Foundation
import UIKit

struct ContactsListSectionModel: Hashable {
    let header: String
    let items: [ContactCellViewModel]
}

class ContactsListDiffableDataSource: UITableViewDiffableDataSource<ContactsListSectionModel, ContactCellViewModel> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.snapshot().sectionIdentifiers[safe: section]?.header
    }
}
