//
//  ProgressHUD.swift
//  MLApp
//
//  Created by Kyle McGrew on 2/16/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

class ProgressHUD {
    private var popupWindow: UIWindow?
    
    func show() {
        popupWindow = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = UIViewController()
        rootViewController.view.isUserInteractionEnabled = false
        popupWindow?.rootViewController = rootViewController
        popupWindow?.windowLevel = UIWindowLevelAlert
        popupWindow?.backgroundColor = UIColor.clear
        
        let width = UIScreen.main.bounds.width * 0.3
        let progress = UIView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        progress.layer.cornerRadius = 5.0
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        progress.addSubview(indicator)
        
        indicator.centerXAnchor.constraint(equalTo: progress.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: progress.centerYAnchor).isActive = true
        
        popupWindow?.addSubview(progress)
        popupWindow?.makeKeyAndVisible()
        
        progress.centerXAnchor.constraint(equalTo: popupWindow!.centerXAnchor).isActive = true
        progress.centerYAnchor.constraint(equalTo: popupWindow!.centerYAnchor).isActive = true
        progress.widthAnchor.constraint(equalToConstant: width).isActive = true
        progress.heightAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func hide() {
        popupWindow = nil
    }
}
