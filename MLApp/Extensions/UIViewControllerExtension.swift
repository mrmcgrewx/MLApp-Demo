//
//  UIViewControllerExtension.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/9/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

extension UIViewController {
    private class func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T
    {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    class func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self
    {
        return instantiateControllerInStoryboard(storyboard, identifier: identifier)
    }
    
    class func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self
    {
        return instantiateControllerInStoryboard(storyboard, identifier: nameOfClass)
    }
    
    class func controllerFromStoryboard(_ storyboard: Storyboards) -> Self
    {
        return controllerInStoryboard(UIStoryboard(name: storyboard.rawValue, bundle: nil), identifier: nameOfClass)
    }
    
    func hideBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showError(_ error: Error) {
        var message: String?
        
        switch error {
        case let netError as NetworkErrors:
            message = networkErrorMessage(netError)
        case let parseError as SerializationError:
            message = serializationErrorMessage(parseError)
        default:
            message = error.localizedDescription
        }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private
    private func networkErrorMessage(_ error: NetworkErrors) -> String {
        switch error {
        case .badInput:
            return "Bad input"
        case .noData:
            return "No data"
        case .badRequest(let msg), .forbidden(let msg), .internalServerError(let msg), .manyRequests(let msg), .notFound(let msg), .unauthorized(let msg), .unknown(let msg):
            return msg
        }
    }
    
    private func serializationErrorMessage(_ error: SerializationError) -> String {
        var message = "Can't serialize a response."
        if case .missing(let name) = error {
            message.append("Missing \(name)")
        }
        return message
    }
    
    
}
