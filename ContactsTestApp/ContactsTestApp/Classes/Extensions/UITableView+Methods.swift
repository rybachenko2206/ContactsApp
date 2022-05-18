//
//  UITableView+Methods.swift
//
//  Created by Roman Rybachenko on 1/17/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(_: T.Type) where T: ReusableCell {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T where T: ReusableCell {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell at indexPath \(indexPath) with identifier \(cellType.reuseIdentifier) matching type \(cellType.self).")
        }
        
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cellType: T.Type = T.self) -> T? where T: ReusableCell {
        guard let cell =  self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self).")
        }
        
        return cell
    }
}
