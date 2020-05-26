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
    
    /// Present an SPAlert with custom content
    /// - Parameters:
    ///   - title: The title of the alert
    ///   - message: The message of the alert
    ///   - image: The image of the alert
    mutating func present(title: String, message: String? = nil, image: UIImage? = nil) {
        if spAlert != nil { spAlert.dismiss() }
        if image == nil {
            spAlert = SPAlertView(message: title)
        } else {
            guard let image = image else { fatalError() }
            spAlert = SPAlertView(title: title, message: message, image: image)
        }
        
        spAlert.duration = 0.5
        spAlert.present()
    }
    
    
    /// Present an SPAlert with the preset
    /// - Parameters:
    ///   - title: The title of the content
    ///   - message: The message of the content
    ///   - preset: The preset
    mutating func present(title: String, message: String? = nil, preset: SPAlertPreset) {
        if spAlert != nil { spAlert.dismiss() }
        spAlert = SPAlertView(title: title, message: message, preset: preset)
        spAlert.duration = 0.5
        
        spAlert.present()
    }
}
