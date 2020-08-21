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
    var image: UIImage?
    var filters: [FilterName]
    
    init(name: String, image: UIImage?, filters: [FilterName]) {
        self.name = name
        self.image = image == nil ? Self.placeholderImage : image
        self.filters = filters
    }
    
    static func == (rhs: FilterCollection, lhs: FilterCollection) -> Bool {
        return rhs.name == lhs.name
    }
    
    static let aCollection = FilterCollection(name: "A Collection", image: UIImage(named: "A Collection.hero")!, filters: [.A1, .A2, .A3, .A4, .A5])
    static let placeholderImage = UIImage(named: "collection-placeholder")!
}
