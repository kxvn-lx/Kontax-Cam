//
//  IconHelper.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

enum IconName: String {
    case flash, timer, reverse, effect, filter
}

struct IconHelper {
    
    private let flash = ["", "bolt.slash.fill", "bolt.fill", "bolt.badge.a.fill"]
    private let timer = ["timer"]
    private let reverse = ["arrow.2.circlepath"]
    private let effect = ["fx"]
    private let filter = ["paintbrush.fill"]
    
    
    static let shared = IconHelper()
    private init () { }
    
    func getIcon(iconName: IconName, currentIcon: String?) -> (UIImage, Int?) {
        
        switch iconName {
        case .flash:
            let currentIcon = currentIcon == nil ? flash[0] : currentIcon
            var nextIndex = flash.firstIndex{ $0 == currentIcon }! + 1
            nextIndex = nextIndex >= flash.count ? 1 : nextIndex
            
            let image = getIconImage(iconName: flash[nextIndex])
            image.accessibilityIdentifier = flash[nextIndex]
            
            return (image, nextIndex)
            
        case .timer:
            let image = getIconImage(iconName: timer[0])
            return (image, nil)
            
        case .reverse:
            let image = getIconImage(iconName: reverse[0])
            return (image, nil)
            
        case .effect:
            let image = getIconImage(iconName: effect[0])
            return (image, nil)
            
        case .filter:
            let image = getIconImage(iconName: filter[0])
            return (image, nil)
        }
    }
    
    
    /// Get the icon in UImage form from the given icon name
    /// - Parameter iconName: The icon name in string format
    /// - Returns: The icon in UIImage
    private func getIconImage(iconName: String) -> UIImage {
        return (UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate))!
    }
    
    
}
