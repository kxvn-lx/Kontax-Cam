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
    
    func read( completion: ( ([UIImage]) -> ()) ) {
        var images: [UIImage] = []
        
        let fileManager = FileManager.default
        let documentsPath = getDocumentsDirectory().path
        
        do {
            let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentsPath)")
            for fileName in fileNames {
                let imageURL = URL(fileURLWithPath: documentsPath).appendingPathComponent(fileName)
                if let image = UIImage(contentsOfFile: imageURL.path) {
                    image.accessibilityIdentifier = fileName
                    images.append(image)
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        completion(images)
    }
    
    /// getDocumentsDirectory() is a little helper function to locate the user's documents directory where you can save app files.
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
