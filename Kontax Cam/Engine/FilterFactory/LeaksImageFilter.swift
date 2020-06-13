//
//  LeaksImageFilter.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 13/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import GPUImage

enum LeaksName: String, CaseIterable {
    case leaks1
}

class LeaksImageFilter: ImageFilterProtocol {
    
    private let selectedLeaksFilter: LeaksName = .leaks1
    private let strength: Float = 1.0
    
    func process(imageToEdit image: UIImage) -> UIImage? {
        
        guard let leaksImage = UIImage(named: selectedLeaksFilter.rawValue) else { fatalError("Invalid name!") }
        
        var editedImage: UIImage?
        let output = PictureOutput()
        output.encodedImageFormat = .jpeg
        output.imageAvailableCallback = { outputImage in
            editedImage = outputImage.remakeOrientation(fromImage: image)
        }
        
        let blendMode = ScreenBlend()
        let opacityBlend = OpacityAdjustment()
        opacityBlend.opacity = strength
        
        let imageInput = PictureInput(image: image)
        let leaksInput = PictureInput(image: leaksImage)
        
        imageInput --> blendMode
        leaksInput --> opacityBlend --> blendMode --> output
        
        imageInput.processImage(synchronously: true)
        leaksInput.processImage(synchronously: true)
        
        return editedImage
    }
}
