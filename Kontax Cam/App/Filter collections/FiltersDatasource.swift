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
    case HUE1, HUE2, HUE3, HUE4, HUE5
    case BW1, BW2, BW3, BW4
}

extension FiltersCollectionViewController {
    
    /// Populate the filters collection list
    func populateSection() {
        // Use placeholder image temporarily (unless someone wishes to contribute on a photo 😊)
        let b = FilterCollection(name: "B Collection", image: UIImage(named: "B Collection.hero"), filters: [.B1, .B2, .B3, .B4, .B5])
        let hue1 = FilterCollection(name: "HUE1 Collection", image: UIImage(named: "HUE1 Collection.hero"), filters: [.HUE1, .HUE2, .HUE3, .HUE4, .HUE5])
        let bw = FilterCollection(name: "BW Collection", image: UIImage(named: "BW Collection.hero"), filters: [.BW1, .BW2, .BW3, .BW4])
        
        self.filterCollections = [
            FilterCollection.aCollection,
            b,
            hue1,
            bw
        ]
    }
}
