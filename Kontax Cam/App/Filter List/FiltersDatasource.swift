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

struct FilterCollection {
    var name: String
    var image: UIImage
    var filters: [FilterName]
}

extension FiltersCollectionViewController {
    
    func populateSection() {
        
        
        let a = FilterCollection(name: "A Collection", image: UIImage(named: "ACollection")!, filters: [.a1, .a2, .a3, .a4, .a5, .a6])
        let b = FilterCollection(name: "B Collection", image: UIImage(named: "collection-placeholder")!, filters: [.b2, .b2, .b3])
        
        self.filterSections = [a, b]
        
    }
    
//    fileprivate func didSelectItem(_ item: FilterItem) {
//        TapticHelper.shared.mediumTaptic()
//
//        LUTImageFilter.selectedLUTFilter = FilterName(rawValue: item.title)!
//        delegate?.filterListDidSelectFilter()
//
//        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
//    }
}
