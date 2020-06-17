//
//  FiltersCollectionViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 28/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import PanModal

private let reuseIdentifier = "filtersCell"
private let headerIdentifier = "filtersHeader"

protocol FilterListDelegate: class {
    /// Tells the delegate that a filter has been selected
    func filterListDidSelectFilter()
}

class FiltersCollectionViewController: UICollectionViewController {
    
    var sections: [MenuSection] = []
    weak var delegate: FilterListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar(tintColor: .label, title: "Filters", preferredLargeTitle: false, removeSeparator: true)
        
        // 1. Setup the layout
        collectionView.collectionViewLayout = makeLayout()
        collectionView.register(ModalHeaderPresentable.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        // 2. Setup datasource
        self.populateSection()
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
}

// MARK: - CollectionView delegate
extension FiltersCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FiltersCollectionViewCell

        let item = sections[indexPath.section].items[indexPath.row]
        cell.titleLabel.text = item.title.uppercased()
        
        if FilterName(rawValue: item.title) == LUTImageFilter.selectedLUTFilter {
            cell.isFilterSelected = true
            cell.updateStyle()
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        item.action?(item)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? ModalHeaderPresentable else {
            fatalError("Could not dequeue SectionHeader")
        }

        headerView.titleLabel.text = sections[indexPath.section].title
        return headerView
    }
}


extension FiltersCollectionViewController {
    // MARK: - Class functions
    private func createSection() -> NSCollectionLayoutSection {
        let contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = contentInsets
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .fractionalWidth(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInsets
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [makeSectionHeader()]
        
        return section
    }
    
    private func makeLayout() -> UICollectionViewLayout  {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createSection()
        }
        
        // Configure the Layout with interSectionSpacing
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    private func makeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(40))
        
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return layoutSectionHeader
    }
}

extension FiltersCollectionViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return collectionView
    }
}
