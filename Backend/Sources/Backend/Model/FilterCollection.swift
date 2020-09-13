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
        imageURL: "https://kontaxcam.imfast.io/A/A%20Collection.hero.jpg",
        filters: [.A1, .A2, .A3, .A4, .A5]
    )
    public static let placeholderImage = UIImage(named: "collection-placeholder")!
}
