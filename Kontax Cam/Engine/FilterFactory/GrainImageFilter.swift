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
    private let strength: FLoat = 1.0
    
    func process(imageToEdit image: UIImage) -> UIImage? {
        guard let grainImage = UIImage(named: selectedGrainFilter.rawValue) else { fatalError("Invalid name!") }

        var editedImage: UIImage?
        let output = PictureOutput()
        output.encodedImageFormat = .jpeg
        output.imageAvailableCallback = { outputImage in
            editedImage = outputImage.remakeOrientation(fromImage: image)
        }
        
        let blendMode = OverlayBlend()
        let opacityBlend = OpacityAdjustment()
        opacityBlend.opacity = strength
        
        let imageInput = PictureInput(image: image)
        let grainInput = PictureInput(image: grainImage)
        
        imageInput --> blendMode
        grainInput --> opacityBlend --> blendMode --> output
        
        imageInput.processImage(synchronously: true)
        grainInput.processImage(synchronously: true)
        
        return editedImage
    }
}
