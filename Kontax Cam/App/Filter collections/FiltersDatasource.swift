//
//  FiltersDatasource.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 17/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import Backend

extension FiltersCollectionViewController {
    
    /// Populate the filters collection list
    func populateSection() {
        
        let b = FilterCollection(
            name: "B Collection",
            imageURL: "https://i.postimg.cc/9MYkj5wm/B-Collection-hero.jpg",
            filters: [.B1, .B2, .B3, .B4, .B5]
        )
        let hue1 = FilterCollection(
            name: "HUE1 Collection",
            imageURL: "https://i.postimg.cc/qM55rGq3/HUE1-Collection-hero.jpg",
            filters: [.HUE1, .HUE2, .HUE3, .HUE4, .HUE5]
        )
        let bw = FilterCollection(
            name: "BW Collection",
            imageURL: "https://i.postimg.cc/MGk3MKyZ/BW-Collection-hero.jpg",
            filters: [.BW1, .BW2, .BW3, .BW4, .BW5]
        )
        
        self.filterCollections = [
            FilterCollection.aCollection,
            b,
            hue1,
            bw
        ]
    }
}
