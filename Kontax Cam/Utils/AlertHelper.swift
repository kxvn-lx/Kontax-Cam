//
//  AlertHelper.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 25/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct AlertHelper {
    
    static let shared = AlertHelper()
    private init() { }
    
    /// Present a default alert with an OK button.
    func presentDefault(title: String, message: String? = nil, to view: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    /// Present alert with a specified action
    func presentWithCustomAction(title: String? = nil, message: String? = nil, withCustomAction alertActions: [UIAlertAction], to view: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertActions.forEach({
            alert.addAction($0)
        })
        view.present(alert, animated: true, completion: nil)
    }
}
