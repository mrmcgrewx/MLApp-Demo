//
//  ReviewTableCell.swift
//  MLApp
//
//  Created by Kyle McGrew on 2/17/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

class ReviewTableCell: UITableViewCell {
    
    @IBOutlet weak var historyImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
