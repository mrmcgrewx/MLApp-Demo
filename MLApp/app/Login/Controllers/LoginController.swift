//
//  LoginController.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/9/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

class LoginController: UIViewController, LoginView, UITextFieldDelegate {

    var onLoginComplete: ((UserInfo) -> Void)?
    var goToHome: (() -> Void)?
    
    @IBOutlet weak var username: LoginTextField!
    @IBOutlet weak var password: LoginTextField!
    
    var entryService: EntryService?
    private lazy var progressHUD = ProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        self.hideBar()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    //MARK: - Action Functions
    @IBAction func loginAction(_ sender: FancyButton) {
        self.progressHUD.show()
        let user = username.text
        let pass = password.text
        if (user == nil || user == "") {
            return
        }
        if (pass == nil || pass == "") {
           return
        }
        entryService?.login(username: user!, password: pass!, completion: { result in
            self.progressHUD.hide()
            switch result {
            case .data(let userInfo):
                self.onLoginComplete?(userInfo)
            case .error(let error):
                self.showError(error)
            }
        })
    }
    
    //MARK: UITextFieldDelegate Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - Notifications
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if (self.view.frame.origin.y == 0) {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
}
