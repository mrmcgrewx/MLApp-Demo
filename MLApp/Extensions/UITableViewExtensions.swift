//
//  UITableViewExtensions.swift
//  MLApp
//
//  Created by Kyle McGrew on 2/18/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

extension UITableView {
    func animateTable() {
        self.reloadData()
        let cells = self.visibleCells
        
        let tableViewHeight = self.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 0.8, delay: Double(delayCounter) * 0.03, options: .curveEaseOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}
