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
        let imageName = "KontaxCam_\(timestamp).jpg"
        
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
    
    /// Delete the image from the file directory
    /// - Parameters:
    ///   - image: The image to be deleted
    ///   - completion: Completion handler of success
    /// - Returns: The completion handler
    func deleteData(imageToDelete image: UIImage , completion: (Bool) -> ()) {
        guard var imageID = image.accessibilityIdentifier else {
            completion(false)
            return
        }
        
        imageID = String(imageID.dropFirst())
        
        let fileManager = FileManager.default
        let documentsPath = getDocumentsDirectory().path
        
        let fileURL = URL(fileURLWithPath: documentsPath).appendingPathComponent(imageID)
        
        // Delete file in document directory
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
                completion(true)
            } catch {
                print("Could not delete file: \(error)")
                completion(false)
            }
        }
    }
    
    /// getDocumentsDirectory() is a little helper function to locate the user's documents directory where you can save app files.
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
