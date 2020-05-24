//
//  SPAlertHelper.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 24/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import SPAlert
import UIKit

struct SPAlertHelper {
    
    private var spAlert: SPAlertView!
    
    static var shared = SPAlertHelper()
    private init() { }
    
    mutating func present(title: String, message: String? = nil, image: UIImage? = nil) {
        if spAlert != nil { spAlert.dismiss() }
        if image == nil {
            spAlert = SPAlertView(message: title)
        } else {
            guard let image = image else {
                fatalError()
            }
            spAlert = SPAlertView(title: title, message: message, image: image)
        }
        
        spAlert.present()
    }
}
