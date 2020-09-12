//
//  UIBarButtonItem.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 12/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    var isHidden: Bool {
        get {
            return !isEnabled && tintColor == .clear
        }
        set {
            tintColor = newValue ? .clear : nil
            isEnabled = !newValue
        }
    }
}
