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
    case colour, datestamp, grain, dust, leaks
}

extension FilterType: CustomStringConvertible {
    var description: String {
      get {
        switch self {
        case .lut: return "LUT"
        case .grain: return "Grain"
        case .dust: return "Dust"
        case .leaks: return "Light leaks"
        case .datestamp: return "Datestamp"
        case .colour: return "Colour leaks"
        }
      }
    }
    
    var iconName: String {
        get {
            switch self {
            case .lut: return ""
            case .grain: return "grain.icon"
            case .dust: return "dust.icon"
            case .leaks: return "leaks.icon"
            case .datestamp: return "calendar"
            case .colour: return "color.icon"
            }
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
