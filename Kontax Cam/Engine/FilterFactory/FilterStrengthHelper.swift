//
//  FilterStrength.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 20/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct FilterStrength {
    
    static var grainStrength: Float = 1.0
    
    static let shared = FilterStrength()
    private init() { }
}
