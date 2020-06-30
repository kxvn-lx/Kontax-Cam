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
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { _ in }
        }
    }
    
    func saveImageToAlbum(_ image: UIImage, completion: @escaping ((Bool) -> Void)) {
        if let collection = fetchAssetCollection() {
            self.saveImageToAssetCollection(image, collection: collection) { (success) in
                completion(success)
            }
        } else {
            // Album does not exist, create it and attempt to save the image
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)
            }, completionHandler: { (success: Bool, error: Error?) in
                if let err = error {
                    print("Could not create the album. Error: \(err)")
                    completion(false)
                    return
                }

                if let newCollection = self.fetchAssetCollection() {
                    self.saveImageToAssetCollection(image, collection: newCollection) { (success) in
                        completion(success)
                    }
                }
            })
        }
    }

    private func fetchAssetCollection() -> PHAssetCollection? {
        let fetchOption = PHFetchOptions()
        fetchOption.predicate = NSPredicate(format: "title == '" + self.albumName + "'")

        let fetchResult = PHAssetCollection.fetchAssetCollections(
            with: PHAssetCollectionType.album,
            subtype: PHAssetCollectionSubtype.albumRegular,
            options: fetchOption)

        return fetchResult.firstObject
    }

    private func saveImageToAssetCollection(_ image: UIImage, collection: PHAssetCollection, completion: @escaping ((Bool) -> Void)) {

        PHPhotoLibrary.shared().performChanges({

            let creationRequest = PHAssetCreationRequest.creationRequestForAsset(from: image)
            if let request = PHAssetCollectionChangeRequest(for: collection),
                let placeHolder = creationRequest.placeholderForCreatedAsset {
                request.addAssets([placeHolder] as NSFastEnumeration)
            }
        }, completionHandler: { (success: Bool, error: Error?) in
            if let err = error {
                print("Could not save the image. Error: \(err)")
            }
            completion(success)
        })
    }
}
