//
//  PhotoLibraryEngine.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import Photos
import UIKit

class PhotoLibraryEngine {
    private let albumName = "Kontax Cam"
    private var assetCollection: PHAssetCollection!
    
    init() {
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }

    }
    
    func checkStatus( completion: @escaping ((Bool) -> ()) ) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    print("Album created.")
                    self.createAlbum()
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    /// Save the image to the library
    /// - Parameters:
    ///   - image: The image that will be saved
    ///   - completion: Completion with given Bool and Error
    /// - Returns: nil
    func save(_ image: UIImage, completion: @escaping ((Bool, Error?) -> ())) {
        if assetCollection == nil {
            print("PhotoLibraryEngine: assetCollection is nil")
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
            let enumeration: NSArray = [assetPlaceHolder!]
            albumChangeRequest!.addAssets(enumeration)
            
        }, completionHandler: { result, error in
            completion(result, error)
        })
    }

    private func createAlbum() {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)
        }) { success, error in
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum()
            } else {
                print("error \(String(describing: error))")
            }
        }
    }
    
    private func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }
}
