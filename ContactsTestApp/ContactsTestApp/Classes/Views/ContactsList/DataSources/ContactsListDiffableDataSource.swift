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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let cellVm = itemIdentifier(for: indexPath)
//                let section = sectionIdentifier(for: indexPath.section)  // from iOS 15+ :(
        else { return }
        
        var currentSnapshot = snapshot()
        
        // we have section titles if we don't check is the last row is deleting
        // there will leave section with title but without content
        if let section = currentSnapshot.sectionIdentifier(containingItem: cellVm),
           section.items.count == 1
        {
            currentSnapshot.deleteSections([section])
        } else {
            currentSnapshot.deleteItems([cellVm])
        }
        
        apply(currentSnapshot)
        
        cellVm.deleteContact()
    }
}
