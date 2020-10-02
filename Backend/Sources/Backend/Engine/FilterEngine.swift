//
//  FilterEngine.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 27/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

public class FilterEngine {
    public var allowedFilters: [FilterType] = []
    
    public static let shared = FilterEngine()
    private init() { }
    
    public func process(image: UIImage, selectedFilters: [FilterType], lut: FilterName?) -> UIImage? {
        print("Alllowed filters: \(selectedFilters)")
        var image = image
        
        // LUT is always enabled by default
        let lutImageFilter = LUTImageFilter()
        if let lutImage = lutImageFilter.process(filterName: lut, imageToEdit: image) {
            image = lutImage
        }
        
        for filter in selectedFilters {
            print("🛠 Current filter: \(filter.description)")
            let filterObj = FilterFactory.shared.getFilter(ofFilterType: filter)
            guard let editedImage = filterObj.process(imageToEdit: image) else { return image }
            image = editedImage
            print("✅ \(filter.description) finished.")
        }
        return image
    }
    
    /// Process the image with all the allowed filters
    /// - Parameter originalImage: The original image
    /// - Returns: The edited image
    public func process(originalImage: UIImage) -> UIImage? {
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
