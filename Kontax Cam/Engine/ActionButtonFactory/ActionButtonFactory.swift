//
//  ActionButtonFactory.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 23/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

enum ActionType {
    case flash
}

class ActionButtonFactory {
    
    /// The actions that will be presented on the main screen
    let actionButtons: [UIButton] = [
        FlashAction(),
        TimerAction(),
        ReverseCamAction(),
        fxAction(),
        filterAction()
    ]
    
    static let shared = ActionButtonFactory()
    private init() { }
    
}
