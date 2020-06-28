//
//  FilterEngine.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 27/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

class FilterEngine {
    
    var allowedFilters: [FilterType] = []
    
    static let shared = FilterEngine()
    private init() { }
    
    
    /// Process the image with all the allowed filters
    /// - Parameter originalImage: The original image
    /// - Returns: The edited image
    func process(originalImage: UIImage) -> UIImage? {
        print("Alllowed filters: \(allowedFilters)")
        var image = originalImage
        
        // LUT is always enabled by default
        let lutObj = FilterFactory.shared.getFilter(ofFilterType: .lut)
        guard let editedImage = lutObj.process(imageToEdit: image) else { fatalError("LUT not working.") }
        image = editedImage
        
        // Iterate through all the selected effects
        for filter in allowedFilters {
            print("🛠 Current filter: \(filter.description)")
            let filterObj = FilterFactory.shared.getFilter(ofFilterType: filter)
            guard let editedImage = filterObj.process(imageToEdit: image) else { fatalError("\(filter) filter is not working.") }
            image = editedImage
            print("✅ \(filter.description) finished.")
        }
        return image
    }
}
