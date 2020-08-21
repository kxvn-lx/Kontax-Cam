//
//  AlertHelper.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 25/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {
    
    static let shared = AlertHelper()
    private init() { }
    
    /// Present alert with a specified action
    func presentWithCustomAction(title: String? = nil, message: String? = nil, withCustomAction alertActions: [UIAlertAction], to view: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertActions.forEach({
            alert.addAction($0)
        })
        view.present(alert, animated: true, completion: nil)
    }
    
    /// Present a default alert view with an OK button.
    func presentOKAction(withTitle title: String, andMessage message: String? = nil, to viewController: UIViewController?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}
