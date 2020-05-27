//
//  GrainImageFilter.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 27/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import GPUImage
import UIKit

enum GrainName: String, CaseIterable {
    case grain1
}

class GrainImageFilter: ImageFilter {
    
    static var selectedGrainFilter: GrainName? = .grain1
    
    /// Proccess the image with the selected grain filter
    /// - Parameter image: The image that will be overlayed with grain
    /// - Returns: The image either exist or not
    func process(imageToEdit image: UIImage) -> UIImage? {
        guard let grainName = GrainImageFilter.selectedGrainFilter else { fatalError("No grain filter selected") }
        guard let grainImage = UIImage(named: grainName.rawValue) else { fatalError("Invalid name!") }

        var editedImage: UIImage?
        let output = PictureOutput()
        output.encodedImageFormat = .jpeg
        output.imageAvailableCallback = { outputImage in
            guard let tempImage = outputImage.cgImage else { fatalError("Unable to create CGImage from UIImage") }
            editedImage = UIImage(cgImage: tempImage, scale: 1.0, orientation: image.imageOrientation)
        }
        
        let overlayBlend = OverlayBlend()
        let opacityBlend = OpacityAdjustment()
        opacityBlend.opacity = 1.0
        
        let imageInput = PictureInput(image: image)
        let grainInput = PictureInput(image: grainImage)
        
        imageInput --> overlayBlend
        grainInput --> opacityBlend --> overlayBlend --> output
        
        imageInput.processImage(synchronously: true)
        grainInput.processImage(synchronously: true)
        
        return editedImage
    }
}
