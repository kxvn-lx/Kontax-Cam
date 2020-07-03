//
//  FilterType.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 13/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

enum FilterType: Int, CaseIterable, Codable {
    case lut
    case colourleaks, datestamp, grain, dust, lightleaks
}

extension FilterType: CustomStringConvertible {
    var description: String {
        switch self {
        case .lut: return "LUT"
        case .grain: return "Grain"
        case .dust: return "Dust"
        case .lightleaks: return "Light leaks"
        case .datestamp: return "Datestamp"
        case .colourleaks: return "Colour leaks"
        }
    }
    
    var iconName: String {
        switch self {
        case .lut: return ""
        case .grain: return "grain.icon"
        case .dust: return "dust.icon"
        case .lightleaks: return "leaks.icon"
        case .datestamp: return "calendar"
        case .colourleaks: return "color.icon"
        }
    }
}

extension FilterType: Equatable {
    static func < (rhs: FilterType, lhs: FilterType) -> Bool {
        return rhs.rawValue < lhs.rawValue
    }
    
    static func > (rhs: FilterType, lhs: FilterType) -> Bool {
        return rhs.rawValue > lhs.rawValue
    }
}
