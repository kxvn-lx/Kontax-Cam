//
//  FilterCollection.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 18/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

struct FilterCollection: Equatable {
    var name: String
    var imageURL: String
    var filters: [FilterName]
    
    static func == (rhs: FilterCollection, lhs: FilterCollection) -> Bool {
        return rhs.name == lhs.name
    }
    
    static let aCollection = FilterCollection(
        name: "A Collection",
        imageURL: "https://kontaxcam.imfast.io/A/A%20Collection.hero.jpg",
        filters: [.A1, .A2, .A3, .A4, .A5]
    )
    static let placeholderImage = UIImage(named: "collection-placeholder")!
}
