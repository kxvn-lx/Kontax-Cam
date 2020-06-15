//
//  DustImageFilter.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 13/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import GPUImage
import UIKit


class DustImageFilter: ImageFilterProtocol {
    
    private enum DustName: String, CaseIterable {
        case dust1
    }

    private let selectedDustFilter: DustName = .dust1
    private let strength: Float = 1.0
    
    func process(imageToEdit image: UIImage) -> UIImage? {
        
        guard let dustImage = UIImage(named: selectedDustFilter.rawValue) else { fatalError("Invalid name!") }
        
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
        let dustInput = PictureInput(image: dustImage)
        
        imageInput --> blendMode
        dustInput --> opacityBlend --> blendMode --> output
        
        imageInput.processImage(synchronously: true)
        dustInput.processImage(synchronously: true)
        
        return editedImage
    }
}
