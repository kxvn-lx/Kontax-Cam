//
//  UIView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 15/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Get the safe area layout of the device
    /// - Returns: The safe area layout
    func getSafeAreaInsets() -> UIEdgeInsets {
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            return window.safeAreaInsets
        } else {
            return .zero
        }
    }
}
