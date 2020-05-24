//
//  IconHelper.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct IconHelper {
    
    static let shared = IconHelper()
    private init () { }
    
    /// Get the icon in UImage form from the given icon name
    /// - Parameter iconName: The icon name in string format
    /// - Returns: The icon in UIImage
    func getIconImage(iconName: String) -> UIImage {
        return (UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate))!
    }
    
    
}
