//
//  ActionButtonFactory.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 23/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct ActionButtonFactory {
    
    /// The actions that will be presented on the main screen
    let actionButtons: [UIButton] = [
        FlashAction(),
        TimerAction(),
        ReverseCamAction(),
        FxAction(),
        FilterAction(),
        GridAction()
    ]
    
    static let shared = ActionButtonFactory()
    private init() { }
    
}
