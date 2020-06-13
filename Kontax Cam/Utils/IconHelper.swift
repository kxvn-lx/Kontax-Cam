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
    
    func getIconName(currentIcon: String?, iconImageArray: [String]) -> (UIImage, Int?) {
        let currentIcon = currentIcon == nil ? iconImageArray[0] : currentIcon
        var nextIndex = iconImageArray.firstIndex{ $0 == currentIcon }! + 1
        nextIndex = nextIndex >= iconImageArray.count ? 1 : nextIndex
        
        let image = IconHelper.shared.getIconImage(iconName: iconImageArray[nextIndex])
        image.accessibilityIdentifier = iconImageArray[nextIndex]
        
        return (image, nextIndex)
    }
    
    /// Get the icon in UImage form from the given icon name
    /// - Parameter iconName: The icon name in string format
    /// - Returns: The icon in UIImage
    func getIconImage(iconName: String) -> UIImage {
        if let systemImage = UIImage(systemName: iconName) {
            return systemImage.withRenderingMode(.alwaysTemplate)
        } else if let customImage = UIImage(named: iconName) {
            return customImage
        } else {
            fatalError("Unable to get image")
        }
        
    }
    
    
}
