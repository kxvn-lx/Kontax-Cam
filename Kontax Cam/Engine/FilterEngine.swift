//
//  FilterEngine.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 27/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct FilterEngine {
    
    let allowedFilters: [FilterType] = [
        .LUT, .grain
    ]
    
    init() { }
    
    func process(originalImage: UIImage) -> UIImage? {
        var image = originalImage
        
        for filter in allowedFilters {
            
            let filterObj = FilterFactory.shared.getFilter(ofFilterType: filter)
            
            guard let editedImage = filterObj.process(imageToEdit: image) else { return nil }
            image = editedImage
        }
        return image
    }
}
