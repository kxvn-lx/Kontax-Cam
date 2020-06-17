//
//  FiltersDatasource.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 17/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

enum FilterName: String, CaseIterable {
    case a1, a2, a3, a4, a5, a6
    case b1, b2, b3
}

extension FiltersCollectionViewController {
    
    func populateSection() {
        
        let aSection = MenuSection(
            title: "A Collection",
            items: [
                MenuItem(
                    title: FilterName.a1.rawValue,
                    action: { [weak self] in self?.didSelectItem($0) }
                ),
                MenuItem(
                    title: FilterName.a2.rawValue,
                    action: { [weak self] in self?.didSelectItem($0) }
                ),
                MenuItem(
                    title: FilterName.a3.rawValue,
                     action: { [weak self] in self?.didSelectItem($0) }
                ),
                MenuItem(
                    title: FilterName.a4.rawValue,
                     action: { [weak self] in self?.didSelectItem($0) }
                ),
                MenuItem(
                    title: FilterName.a5.rawValue,
                    action: { [weak self] in self?.didSelectItem($0) }
                ),
                MenuItem(
                    title: FilterName.a6.rawValue,
                    action: { [weak self] in self?.didSelectItem($0) }
                )
            ],
           action: nil)
        
        let bSection = MenuSection(
            title: "B Collection",
            items: [
                MenuItem(
                    title: FilterName.b1.rawValue,
                    action: { [weak self] in self?.didSelectItem($0) }
                ),
                MenuItem(
                    title: FilterName.b2.rawValue,
                    action: { [weak self] in self?.didSelectItem($0) }
                ),
                MenuItem(
                    title: FilterName.b3.rawValue,
                    action: { [weak self] in self?.didSelectItem($0) }
                ),
            ],
           action: nil)
        
        self.sections = [aSection, bSection]
    }
    
    fileprivate func didSelectItem(_ item: MenuItem) {
        TapticHelper.shared.mediumTaptic()
        
        LUTImageFilter.selectedLUTFilter = FilterName(rawValue: item.title!)!
        delegate?.filterListDidSelectFilter()
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
