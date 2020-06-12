//
//  DustImageFilter.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 13/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import GPUImage
import UIKit

enum DustName: String, CaseIterable {
    case dust1
}

class DustImageFilter: ImageFilterProtocol {

    private let selectedDustFilter: DustName = .dust1
    
    func process(imageToEdit image: UIImage) -> UIImage? {
        
        guard let dustImage = UIImage(named: selectedDustFilter.rawValue) else { fatalError("Invalid name!") }
        
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
        let dustInput = PictureInput(image: dustImage)
        
        imageInput --> overlayBlend
        dustInput --> opacityBlend --> overlayBlend --> output
        
        imageInput.processImage(synchronously: true)
        dustInput.processImage(synchronously: true)
        
        return editedImage
    }
}
