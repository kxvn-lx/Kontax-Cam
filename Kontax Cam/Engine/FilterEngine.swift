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
    
    func process(originalImage: UIImage) -> UIImage? {
        var image = originalImage
        
        // LUT is always enabled by default
        let lutObj = FilterFactory.shared.getFilter(ofFilterType: .lut)
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
