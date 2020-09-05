//
//  UIImage.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 15/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

extension UIImage {
    func getFileSizeInfo(allowedUnits: ByteCountFormatter.Units = .useMB, countStyle: ByteCountFormatter.CountStyle = .file) -> String? {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = allowedUnits
        formatter.countStyle = countStyle
        
        guard let imageData = jpegData(compressionQuality: 1.0) else { return nil }
        return formatter.string(fromByteCount: Int64(imageData.count))
    }
    
    func remakeOrientation(fromImage image: UIImage, withScale scale: CGFloat = 1.0) -> UIImage {
        return UIImage(cgImage: self.cgImage!, scale: scale, orientation: image.imageOrientation)
    }
    
    func alpha(_ value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
