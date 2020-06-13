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
    private init() {
        guard let filtersData = UserDefaultsHelper.shared.getData(type: Any.self, forKey: .userFxList) as? NSData else { return }
        guard let allowedFilters = try? PropertyListDecoder().decode([FilterType].self, from: filtersData as Data) else { return }
        self.allowedFilters = allowedFilters
    }
    
    
    /// Process the image with all the allowed filters
    /// - Parameter originalImage: The original image
    /// - Returns: The edited image
    func process(originalImage: UIImage) -> UIImage? {
        var image = originalImage
        
        // LUT is always enabled by default
        let lutObj = FilterFactory.shared.getFilter(ofFilterType: .lut)
        guard let editedImage = lutObj.process(imageToEdit: image) else { fatalError("LUT not working.") }
        image = editedImage
        
        // Iterate through all the selected effects
        for filter in allowedFilters {
            let filterObj = FilterFactory.shared.getFilter(ofFilterType: filter)
            guard let editedImage = filterObj.process(imageToEdit: image) else { fatalError("\(filter) filter is not working.") }
            image = editedImage
        }
        return image
    }
}
