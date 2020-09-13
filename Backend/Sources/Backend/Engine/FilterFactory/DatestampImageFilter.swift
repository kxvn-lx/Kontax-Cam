//
//  DatestampImageFilter.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 15/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

public class DatestampImageFilter: ImageFilterProtocol {
    
    private var currentDate: String = {
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [.year, .month, .day]
        
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        
        let year = String(dateTimeComponents.year!).dropFirst(2)
        let month = String(dateTimeComponents.month!)
        let day = String(dateTimeComponents.day!)
        
        return "\(day)  \(month) '\(year)"
    }()
    
    public func process(imageToEdit image: UIImage) -> UIImage? {
        
        let xPos: CGFloat = image.size.width * 0.7
        let yPos: CGFloat = image.size.height * 0.9
        let fontSize: CGFloat = image.size.width * 0.038

        UIGraphicsBeginImageContext(image.size)
        
        // 1. Draw the photo
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // 2. Configure datestamp
        let rect = CGRect(x: 0, y: 0, width: 1000, height: 200)
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        
        let datestamp = renderer.image { ctx in
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Date Stamp Alt", size: fontSize)!,
                .foregroundColor: UIColor(displayP3Red: 249/255, green: 148/255, blue: 60/255, alpha: 1)
            ]
            
            let attributedString = NSAttributedString(string: currentDate, attributes: attrs)
            ctx.cgContext.setShadow(offset: .zero, blur: 15, color: UIColor.red.cgColor)
            attributedString.draw(in: rect)
        }
        
        // 3. Draw the datestamp
        datestamp.draw(in: CGRect(x: xPos, y: yPos, width: rect.width, height: rect.height))

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
