//
//  DatestampImageFilter.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 15/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class DatestampImageFilter: ImageFilterProtocol {
    
    private let datestampLabel = DatestampLabel()
    private let strength: Float = 1.0
    
    
    func process(imageToEdit image: UIImage) -> UIImage? {
        
        var datestampRect: CGRect!
        
        
        switch image.imageOrientation {
        case .up, .down, .upMirrored, .downMirrored:
            // Landscape
            datestampLabel.font = datestampLabel.font.withSize(image.size.width * 0.035)
            datestampRect = CGRect(x: image.size.width * 0.7, y: image.size.height * 0.9, width: image.size.width, height: datestampLabel.font.lineHeight)
            
        case .left, .right, .leftMirrored, .rightMirrored:
            // Portrait
            datestampLabel.font = datestampLabel.font.withSize(image.size.height * 0.03)
            datestampRect = CGRect(x: image.size.width * 0.7, y: image.size.height * 0.9, width: image.size.width, height: datestampLabel.font.lineHeight)
            
        default: break
        }
        
        datestampLabel.applyGlow()
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        datestampLabel.drawText(in: datestampRect.integral)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
