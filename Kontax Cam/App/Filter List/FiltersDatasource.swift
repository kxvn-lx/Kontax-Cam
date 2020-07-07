//
//  FiltersDatasource.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 17/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

enum FilterName: String, CaseIterable {
    case a1, a2, a3, a4, a5, a6
    case b1, b2, b3
}

struct FilterCollection: Equatable {
    var name: String
    var image: UIImage
    var filters: [FilterName]
    
    static func == (rhs: FilterCollection, lhs: FilterCollection) -> Bool {
        return rhs.name == lhs.name
    }
    
    static let aCollection = FilterCollection(name: "A Collection", image: UIImage(named: "ACollection")!, filters: [.a1, .a2, .a3, .a4, .a5, .a6])
}

extension FiltersCollectionViewController {
    
    func populateSection() {
        let b = FilterCollection(name: "B Collection", image: UIImage(named: "collection-placeholder")!, filters: [.b2, .b2, .b3])
        
        self.filterCollections = [FilterCollection.aCollection, b]
    }
}
