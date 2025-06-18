//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Rubin Vadim on 23.04.2025.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData()}
    }
}
