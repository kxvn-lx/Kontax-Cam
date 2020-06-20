//
//  FilterStrength.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 20/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

struct FilterValue {
    
    enum Colourleak: CaseIterable {
        case random, red, green, blue
        
        var value: UIColor {
            get {
                switch self {
                case .random: return Colourleak.allCases.dropFirst().randomElement()!.value
                case .red: return .red
                case .green: return .green
                case .blue: return .blue
                }
            }
        }
    }
    
    enum Datestamp: CaseIterable {
        case oldschool, current
    }
    
    static var valueMap: [FilterType: CGFloat] = [.grain: 10.0,
                                                  .colourleaks: 10.0,
                                                  .dust: 10.0,
                                                  .lightleaks: 10.0]

    private init() { }
}

