//
//  UIImage.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 15/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

extension UIImage {
    enum UIImageAlignment {
        case Center, Left, Top, Right, Bottom, TopLeft, BottomRight, BottomLeft, TopRight
    }

    enum UIImageScaleMode {
        case Fill,
        AspectFill,
        AspectFit(UIImageAlignment)
    }
    
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
    
    func scaleImage(width: CGFloat? = nil, height: CGFloat? = nil, scaleMode: UIImageScaleMode = .AspectFit(.Center), trim: Bool = false) -> UIImage? {
        
        let preWidthScale = width.map { $0 / size.width }
        let preHeightScale = height.map { $0 / size.height }
        var widthScale = preWidthScale ?? preHeightScale ?? 1
        var heightScale = preHeightScale ?? widthScale
        switch scaleMode {
        case .AspectFit(_):
            let scale = min(widthScale, heightScale)
            widthScale = scale
            heightScale = scale
        case .AspectFill:
            let scale = max(widthScale, heightScale)
            widthScale = scale
            heightScale = scale
        default:
            break
        }
        let newWidth = size.width * widthScale
        let newHeight = size.height * heightScale
        let canvasWidth = trim ? newWidth : (width ?? newWidth)
        let canvasHeight = trim ? newHeight : (height ?? newHeight)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: canvasWidth, height: canvasHeight), false, 0)

        var originX: CGFloat = 0
        var originY: CGFloat = 0
        switch scaleMode {
        case .AspectFit(let alignment):
            switch alignment {
            case .Center:
                originX = (canvasWidth - newWidth) / 2
                originY = (canvasHeight - newHeight) / 2
            case .Top:
                originX = (canvasWidth - newWidth) / 2
            case .Left:
                originY = (canvasHeight - newHeight) / 2
            case .Bottom:
                originX = (canvasWidth - newWidth) / 2
                originY = canvasHeight - newHeight
            case .Right:
                originX = canvasWidth - newWidth
                originY = (canvasHeight - newHeight) / 2
            case .TopLeft:
                break
            case .TopRight:
                originX = canvasWidth - newWidth
            case .BottomLeft:
                originY = canvasHeight - newHeight
            case .BottomRight:
                originX = canvasWidth - newWidth
                originY = canvasHeight - newHeight
            }
        default:
            break
        }
        self.draw(in: CGRect(x: originX, y: originY, width: newWidth, height: newHeight))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
