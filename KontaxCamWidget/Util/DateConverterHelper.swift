//
//  DateConverterHelper.swift
//  KontaxCamWidgetExtension
//
//  Created by Kevin Laminto on 19/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct DateConverterHelper {
    
    static let shared = DateConverterHelper()
    private init() { }
    
    func convertToDateTime(url: URL) -> (date: String, time: String) {
        if url == Photo.static_photo.url {
            return ( "9 Feb 2019", "6:45 pm" )
        }
        
        let urlString = url.path
        let timestamp = urlString.components(separatedBy: "_").last!.components(separatedBy: ".").first!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        
        let ts = Date(timeIntervalSince1970: (timestamp as NSString).doubleValue)
        let date = formatter.string(from: ts)
        
        formatter.dateFormat = "h:mm a"
        let time = formatter.string(from: ts)
        
        return (date, time)
    }
}
