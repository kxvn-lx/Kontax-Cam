//
//  DustImageFilter.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 13/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

public class DustImageFilter: ImageFilterProtocol {
    private enum DustName: String, CaseIterable {
        case dust1
    }

    private let selectedDustFilter: DustName = .dust1
    private var strength: CGFloat = {
        return RangeConverterHelper.shared.convert(FilterValue.Dust.strength, fromOldRange: [0, 10], toNewRange: [0, 1])
    }()
    
    public func process(imageToEdit image: UIImage) -> UIImage? {
        guard let dustImage = UIImage(named: selectedDustFilter.rawValue) else { fatalError("Invalid name!") }
        print("Applying dust with strength of: \(strength)")
        
        // 1. Begin drawing
        UIGraphicsBeginImageContext(image.size)
        
        // 2. Draw the base image first
        let rect = CGRect(origin: .zero, size: image.size)
        image.draw(in: rect)
        
        // 3. Draw the dust image with screen blend mode
        dustImage.draw(in: rect, blendMode: .screen, alpha: strength)
        
        // 4. Get the blended image and return!
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
