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

protocol FilterListDelegate {
    /// Tells the delegate that a filter has been selected
    func filterListDidSelectFilter(withFilterName filterName: FilterName)
}

enum FilterName: String, CaseIterable {
    // Colour
    case c1, c2
    
    // Black and White
    case bw1
}

class FiltersCollectionViewController: UICollectionViewController {
    
    private let filters: [[FilterName]] = [
        [.c1, .c2],
        [.bw1],
    ]
    
    var delegate: FilterListDelegate?
    var selectedFilterName: FilterName!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar(tintColor: .label, title: "Filters", preferredLargeTitle: false, removeSeparator: true)
        
        // UICollectionView setup
        collectionView.collectionViewLayout = makeLayout()
        
        collectionView.register(ModalHeaderPresentable.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filters.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedFilterName == nil { fatalError("Filter name must not be nil!") }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FiltersCollectionViewCell
        let currentFilter = filters[indexPath.section][indexPath.row]
        
        cell.titleLabel.text = currentFilter.rawValue.uppercased()
        if currentFilter == selectedFilterName {
            cell.isFilterSelected = true
            cell.updateStyle()
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TapticHelper.shared.lightTaptic()
        
        guard let delegate = delegate else { fatalError("Delegate is nil!") }
        delegate.filterListDidSelectFilter(withFilterName: filters[indexPath.section][indexPath.row])
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? ModalHeaderPresentable else {
            fatalError("Could not dequeue SectionHeader")
        }
        
        switch indexPath.section {
        case 0: headerView.titleLabel.text = "Colour"
        case 1: headerView.titleLabel.text = "BW"
        default: break
        }
        
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
