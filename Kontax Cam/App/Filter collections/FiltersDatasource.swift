//
//  FiltersDatasource.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 17/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

enum FilterName: String, CaseIterable {
    case A1, A2, A3, A4, A5
    case B1, B2, B3, B4, B5
    case C1, C2, C3, C4, C5
    case BW1, BW2, BW3, BW4
}

struct FilterCollection: Equatable {
    var name: String
    var image: UIImage = FilterCollection.placeholderImage
    var filters: [FilterName]
    
    static func == (rhs: FilterCollection, lhs: FilterCollection) -> Bool {
        return rhs.name == lhs.name
    }
    
    static let aCollection = FilterCollection(name: "A Collection", filters: [.A1, .A2, .A3, .A4, .A5])
    static let placeholderImage = UIImage(named: "collection-placeholder")!
}

extension FiltersCollectionViewController {
    
    /// Populate the filters collection list
    func populateSection() {
        // Use placeholder image temporarily (unless someone wishes to contribute on a photo 😊)
        let b = FilterCollection(name: "B Collection", filters: [.B1, .B2, .B3, .B4, .B5])
        let c = FilterCollection(name: "C Collection", filters: [.C1, .C2, .C3, .C4, .C5])
        let bw = FilterCollection(name: "BW Collection", filters: [.BW1, .BW2, .BW3, .BW4])
        
        self.filterCollections = [FilterCollection.aCollection, b, c, bw]
    }
}
