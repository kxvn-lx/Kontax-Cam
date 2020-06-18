//
//  FilterFactory.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 27/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

protocol ImageFilterProtocol {
    
    /// Proccess the image with the selected  filter
    /// - Parameter image: The image that will be overlayed with grain
    /// - Returns: The image either exist or not
    func process(imageToEdit image: UIImage) -> UIImage?
}

class FilterFactory {
    
    static let shared = FilterFactory()
    private init() { }
    
    /// Get the filter and returns the object
    /// - Parameters:
    ///   - filterType: The type of the filter
    ///   - filterName: The image name of the ilter as specified in assets folder
    /// - Returns: The ImageFilter ready to be used
    func getFilter(ofFilterType filterType: FilterType) -> ImageFilterProtocol {
        
        switch filterType {
        case .lut: return LUTImageFilter()
        case .grain: return GrainImageFilter()
        case .dust: return DustImageFilter()
        case .leaks: return LeaksImageFilter()
        case .datestamp: return DatestampImageFilter()
        case .colour: return ColourLeaksImageFilter()
        }
    }
}
