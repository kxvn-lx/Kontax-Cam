//
//  ColourLeaksImageFilter.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 18/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

public class ColourLeaksImageFilter: ImageFilterProtocol {
    
    private let selectedColourLeaksFilter = FilterValue.Colourleaks.selectedColourValue
    private var strength: CGFloat = 1.0
    
    public func process(imageToEdit image: UIImage) -> UIImage? {
        print("applying colour leaks value: \(selectedColourLeaksFilter.rawValue)")
        
        // 1. Begin drawing
        UIGraphicsBeginImageContext(image.size)
        
        // 2. Draw the base image first
        let rect = CGRect(origin: .zero, size: image.size)
        image.draw(in: rect)
        
        // 3. Draw the colour image with darken blend mode
        let colourImage = convertToImage(fromColor: selectedColourLeaksFilter.value, withSize: image.size)
        colourImage.draw(in: rect, blendMode: .darken, alpha: strength)
        
        // 4. Get the blended image and return!
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    private func convertToImage(fromColor color: UIColor, withSize size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { (ctx) in
            color.set()
            ctx.fill(CGRect(origin: .zero, size: size))
        }
    }
}
