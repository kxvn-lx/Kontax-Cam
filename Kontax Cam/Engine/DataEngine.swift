//
//  DataEngine.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 25/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct DataEngine {
    
    static let shared = DataEngine()
    private init() { }
    
    /// Save the image data to the device
    /// - Parameter imageData: "The image data ready to be saved"
    func save(imageData: Data) {
        let timestamp = NSDate().timeIntervalSince1970
        let imageName = "KontaxCam_\(timestamp).png"
        
        let filename = getDocumentsDirectory().appendingPathComponent(imageName)
        do {
            try imageData.write(to: filename)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Read data from the file and convert them into array of URLs for reading
    /// - Returns: The array of URLs
    func readDataToURLs() -> [URL] {
        var urls: [URL] = []
        
        let fileManager = FileManager.default
        let documentsPath = getDocumentsDirectory().path
        
        do {
            let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentsPath)")
            for fileName in fileNames {
                let imageURL = URL(fileURLWithPath: documentsPath).appendingPathComponent(fileName)
                urls.append(imageURL)
            }
            
            urls.sort(by: { $0.absoluteString.compare(
                $1.absoluteString, options: .numeric) == .orderedDescending })
            
        } catch {
            print(error.localizedDescription)
        }
        
        return urls
    }
    
    /// getDocumentsDirectory() is a little helper function to locate the user's documents directory where you can save app files.
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
