//
//  GrainImageFilter.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 27/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import GPUImage
import UIKit


class GrainImageFilter: ImageFilterProtocol {
    
    private enum GrainName: String, CaseIterable {
        case grain1
    }

    private let selectedGrainFilter: GrainName = .grain1
    private var strength: CGFloat = 1.0
    
    func process(imageToEdit image: UIImage) -> UIImage? {
        guard let grainImage = UIImage(named: selectedGrainFilter.rawValue) else { fatalError("Invalid name!") }
        
        print("Applying grain with strength of: \(String(describing: strength))")

        var editedImage: UIImage?
        let output = PictureOutput()
        output.encodedImageFormat = .jpeg
        output.imageAvailableCallback = { outputImage in
            editedImage = outputImage.remakeOrientation(fromImage: image)
        }
        
        let blendMode = ScreenBlend()
        
        let imageInput = PictureInput(image: image)
        let grainInput = PictureInput(image: grainImage.alpha(strength))
        
        imageInput --> blendMode
        grainInput --> blendMode --> output
        
        imageInput.processImage(synchronously: true)
        grainInput.processImage(synchronously: true)
        
        return editedImage
    }
}
