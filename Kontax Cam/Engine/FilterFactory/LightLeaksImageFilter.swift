//
//  LightLeaksImageFilter.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 13/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import GPUImage

class LightLeaksImageFilter: ImageFilterProtocol {
    
    private enum LeaksName: String, CaseIterable {
        case leaks1
    }
    
    private let selectedLeaksFilter: LeaksName = .leaks1
    private var strength: CGFloat = {
        return RangeConverterHelper.shared.convert(FilterValue.Lightleaks.strength, fromOldRange: [0, 10], toNewRange: [0, 1])
    }()
    
    func process(imageToEdit image: UIImage) -> UIImage? {
        guard let leaksImage = UIImage(named: selectedLeaksFilter.rawValue) else { fatalError("Invalid name!") }
        print("Applying lightleaks with strength of: \(String(describing: strength))")
        
        var editedImage: UIImage?
        let output = PictureOutput()
        output.encodedImageFormat = .jpeg
        output.imageAvailableCallback = { outputImage in
            editedImage = outputImage.remakeOrientation(fromImage: image)
        }
        
        let blendMode = ScreenBlend()
        
        let imageInput = PictureInput(image: image)
        let leaksInput = PictureInput(image: leaksImage.alpha(strength))
        
        imageInput --> blendMode
        leaksInput --> blendMode --> output
        
        imageInput.processImage(synchronously: true)
        leaksInput.processImage(synchronously: true)
        
        return editedImage
    }
}
