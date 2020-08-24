//
//  GrainImageFilter.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 27/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class GrainImageFilter: ImageFilterProtocol {
    private enum GrainName: String, CaseIterable {
        case grain1
    }
    
    private let selectedGrainFilter: GrainName = .grain1
    private var strength: CGFloat = {
        return RangeConverterHelper.shared.convert(FilterValue.Grain.strength, fromOldRange: [0, 10], toNewRange: [0, 1])
    }()
    
    func process(imageToEdit image: UIImage) -> UIImage? {
        guard let grainImage = UIImage(named: selectedGrainFilter.rawValue) else { fatalError("Invalid grain image name!") }
        print("Applying grain with strength of: \(String(describing: strength))")

        // 1. Begin drawing
        UIGraphicsBeginImageContext(image.size)
        
        // 2. Draw the base image first
        let rect = CGRect(origin: .zero, size: image.size)
        image.draw(in: rect)
        
        // 3. Draw the grain image with screen blend mode
        grainImage.draw(in: rect, blendMode: .screen, alpha: strength)
        
        // 4. Get the blended image and return!
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
