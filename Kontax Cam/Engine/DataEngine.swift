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
        let imageName = "KontaxCam_\(timestamp).jpeg"

        let fileManager = FileManager.default
        let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.kevinlaminto.kontaxcam")?.appendingPathComponent(imageName)
        
        // store image in group container
        fileManager.createFile(atPath: url!.path as String, contents: imageData, attributes: nil)
    }
    
    /// Read data from the file and convert them into array of URLs for reading
    /// - Returns: The array of URLs
    func readDataToURLs() -> [URL] {
        var urls: [URL] = []
        
        let fileManager = FileManager.default
        guard let sharedGroupPath = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.kevinlaminto.kontaxcam")?.path else {
            return urls
        }
        
        do {
            let fileNames = try fileManager.contentsOfDirectory(atPath: "\(sharedGroupPath)").filter({ $0.contains("KontaxCam") })
            
            for fileName in fileNames {
                let imageURL = URL(fileURLWithPath: sharedGroupPath).appendingPathComponent(fileName)
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
    func deleteData(imageURLToDelete url: URL, completion: (Bool) -> Void) {
        let fileManager = FileManager.default
        
        // Delete file in document directory
        if fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.removeItem(at: url)
                completion(true)
            } catch {
                print("Could not delete file: \(error)")
                completion(false)
            }
        }
    }
}

/// Extension for Widgets
extension DataEngine {
    func randomPhoto() -> Photo? {
        guard let randomImageURL = readDataToURLs().randomElement() else {
            return Photo.static_photo
        }
        
        do {
            let imageData = try Data(contentsOf: randomImageURL)
            guard let image = UIImage(data: imageData) else { return nil }
            return Photo(image: image, url: randomImageURL)
            
        } catch {
            print("Error loading image : \(error)")
        }
        
        return nil
    }
}
