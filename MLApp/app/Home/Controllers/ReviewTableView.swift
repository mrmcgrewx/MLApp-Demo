//
//  ReviewTableView.swift
//  MLApp
//
//  Created by Kyle McGrew on 2/17/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

protocol ReviewTableView: NSObjectProtocol, Presentable {
    var onReviewComplete: (() -> Void)? { get set }
}
