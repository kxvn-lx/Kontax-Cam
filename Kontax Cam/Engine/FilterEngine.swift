//
//  FilterEngine.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 27/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

enum FilterType: Int, Equatable, CustomStringConvertible, CaseIterable {
    case LUT, grain
    
    var description: String {
      get {
        switch self {
        case .LUT: return "LUT"
        case .grain: return "Grain"
        }
      }
    }
    
    static func < (rhs: FilterType, lhs: FilterType) -> Bool {
        return rhs.rawValue < lhs.rawValue
    }
    
    static func > (rhs: FilterType, lhs: FilterType) -> Bool {
        return rhs.rawValue > lhs.rawValue
    }
}

class FilterEngine {
    
    var allowedFilters: [FilterType] = []
    
    static let shared = FilterEngine()
    
    private init() { }
    
    func process(originalImage: UIImage) -> UIImage? {
        var image = originalImage
        
        // LUT is always enabled by default
        let lutObj = FilterFactory.shared.getFilter(ofFilterType: .LUT)
        guard let editedImage = lutObj.process(imageToEdit: image) else { fatalError("LUT not working.") }
        image = editedImage
        
        // Iterate through all the selected effects
        for filter in allowedFilters {
            let filterObj = FilterFactory.shared.getFilter(ofFilterType: filter)
            guard let editedImage = filterObj.process(imageToEdit: image) else { fatalError("Some of the filters are not working.") }
            image = editedImage
        }
        return image
    }
}
