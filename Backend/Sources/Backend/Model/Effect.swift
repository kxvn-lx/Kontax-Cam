//
//  Effect.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 18/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

public struct Effect {
    public var name: FilterType
    public var icon: String
    
    public init (name: FilterType, icon: String) {
        self.name = name
        self.icon = icon
    }
}
