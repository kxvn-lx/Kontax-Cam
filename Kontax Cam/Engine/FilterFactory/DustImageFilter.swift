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
    private var strength: CGFloat = 1.0
    
    func process(imageToEdit image: UIImage) -> UIImage? {
        guard let dustImage = UIImage(named: selectedDustFilter.rawValue) else { fatalError("Invalid name!") }
        print("Applying dust with strength of: \(String(describing: strength))")
        
        var editedImage: UIImage?
        let output = PictureOutput()
        output.encodedImageFormat = .jpeg
        output.imageAvailableCallback = { outputImage in
            editedImage = outputImage.remakeOrientation(fromImage: image)
        }
        
        let blendMode = ScreenBlend()
        
        let imageInput = PictureInput(image: image)
        let dustInput = PictureInput(image: dustImage.alpha(strength))
        
        imageInput --> blendMode
        dustInput --> blendMode --> output
        
        imageInput.processImage(synchronously: true)
        dustInput.processImage(synchronously: true)
        
        return editedImage
    }
}
