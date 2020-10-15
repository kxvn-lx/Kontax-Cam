//
//  FilterCollection.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 18/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

public enum FilterName: String, CaseIterable {
    case A1, A2, A3, A4, A5
    case B1, B2, B3, B4, B5
    case HUE1, HUE2, HUE3, HUE4, HUE5
    case BW1, BW2, BW3, BW4, BW5
}

public struct FilterCollection: Equatable {
    public var name: String
    public var imageURL: String
    public var filters: [FilterName]
    
    public init(name: String, imageURL: String, filters: [FilterName]) {
        self.name = name
        self.imageURL = imageURL
        self.filters = filters
    }
    
    public var iapID: String {
        return IAPManager.shared.bundleID + "." + convertToSuffix(name)
    }
    
    private func convertToSuffix(_ str: String) -> String {
        return str.lowercased().replacingOccurrences(of: " ", with: "")
    }
    
    public static func == (rhs: FilterCollection, lhs: FilterCollection) -> Bool {
        return rhs.name == lhs.name
    }
    
    public static let aCollection = FilterCollection(
        name: "A Collection",
        imageURL: "https://i.postimg.cc/P5v1wW4Y/A-Collection-hero.jpg",
        filters: [.A1, .A2, .A3, .A4, .A5]
    )
    
    public static  let imageURLs: [String: [String]] = [
        "A": [
            "https://i.postimg.cc/yN6bm6fF/A-ex1.jpg",
            "https://i.postimg.cc/8CFhQqc2/A-ex2.jpg",
            "https://i.postimg.cc/X7kMdPj6/A-ex3.jpg",
            "https://i.postimg.cc/6pMD1G4H/A-ex4.jpg",
            "https://i.postimg.cc/GpN6bwQG/A-ex5.jpg"
        ],
        "B": [
            "https://i.postimg.cc/43KFL2gd/B-ex1.jpg",
            "https://i.postimg.cc/FK2C2brx/B-ex2.jpg",
            "https://i.postimg.cc/bJkV8Gdf/B-ex3.jpg",
            "https://i.postimg.cc/HnfTCY5k/B-ex4.jpg",
            "https://i.postimg.cc/zGw891fq/B-ex5.jpg"
        ],
        "HUE1": [
            "https://i.postimg.cc/XqFYqBnC/HUE1-ex1.jpg",
            "https://i.postimg.cc/pTcFzjNc/HUE1-ex2.jpg",
            "https://i.postimg.cc/ZnjDrVYt/HUE1-ex3.jpg",
            "https://i.postimg.cc/zBynd7kY/HUE1-ex4.jpg",
            "https://i.postimg.cc/nVQ4Bdzv/HUE1-ex5.jpg"
        ],
        "BW": [
            "https://i.postimg.cc/L84gCvHQ/BW-ex1.jpg",
            "https://i.postimg.cc/Qd69R5C8/BW-ex2.jpg",
            "https://i.postimg.cc/pdphxT5D/BW-ex3.jpg",
            "https://i.postimg.cc/PJzNKv0k/BW-ex4.jpg",
            "https://i.postimg.cc/c1QKdPC5/BW-ex5.jpg"
        ]
    ]
    
    public static let placeholderImage = UIImage(named: "collection-placeholder")!
}
