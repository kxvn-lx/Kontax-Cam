//
//  TapticHelper.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct TapticHelper {
    
    static let shared = TapticHelper()
    private init() { }
    
    /**
     Creates an error Taptic feedback
     */
    func errorTaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    /**
     Creates a success Taptic feedback
     */
    func successTaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /**
     Creates a warning Taptic feedback
     */
    func warningTaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    /**
     Creates a light Taptic feedback
     */
    func lightTaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /**
     Creates a medium Taptic feedback
     */
    func mediumTaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /**
     Creates a heavy Taptic feedback
     */
    func heavyTaptic() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
}
