//
//  HomeController.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/9/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

class HomeController: UIViewController, HomeView {
 
    var onHomeComplete: (() -> Void)?
    var showCamera: ((UserInfo) -> Void)?
    var showReview: (() -> Void)?
    
    var userInfo: UserInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ("Hello " + userInfo.username)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            onHomeComplete?()
        }
    }
    
    //MARK: Actions
    @IBAction func showCameraAction(_ sender: FancyButton) {
        showCamera?(userInfo)
    }
    
    @IBAction func showReviewAction(_ sender: FancyButton) {
        showReview?()
    }
}
