//
//  GrainImageFilter.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 27/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import GPUImage
import UIKit

enum GrainName: String, CaseIterable {
    case grain1
}

class GrainImageFilter: ImageFilterProtocol {
    
    private let selectedGrainFilter: GrainName = .grain1
    
    func process(imageToEdit image: UIImage) -> UIImage? {
        guard let grainImage = UIImage(named: selectedGrainFilter.rawValue) else { fatalError("Invalid name!") }

        var editedImage: UIImage?
        let output = PictureOutput()
        output.encodedImageFormat = .jpeg
        output.imageAvailableCallback = { outputImage in
            editedImage = outputImage.remakeOrientation(fromImage: image)
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
