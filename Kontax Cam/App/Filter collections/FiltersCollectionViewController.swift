//
//  FiltersCollectionViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 28/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import Combine
import SafariServices
import Backend

protocol FilterListDelegate: class {
    /// Tells the delegate that a filter collection has been selected
    func filterListDidSelectCollection(_ collection: FilterCollection)
}

class FiltersCollectionViewController: UICollectionViewController {
    
    var filterCollections = [FilterCollection]()
    var selectedCollection = FilterCollection.aCollection
    weak var delegate: FilterListDelegate?
    private var subscriptionsToken = Set<AnyCancellable>()
    private var initIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addCloseButton()
        self.setNavigationBarTitle("Filter collections".localized)
        self.collectionView.backgroundColor = .systemBackground
        
        // 1. Setup the layout
        collectionView.collectionViewLayout = makeLayout()
        collectionView.register(FiltersCollectionViewCell.self, forCellWithReuseIdentifier: FiltersCollectionViewCell.ReuseIdentifier)
        collectionView.register(FilterHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FilterHeaderView.ReuseIdentifier)
        
        // 2. Setup datasource
        self.populateSection()
        
        observeIAP()
    }
    
    /// Observe IAP changes in real time.
    private func observeIAP() {
        // Observed for live-change on IAP events
        IAPManager.shared.removedIAPs
            .handleEvents(receiveOutput: { [unowned self] removedIAPs in
                
                var purchasedFilters = UserDefaultsHelper.shared.getData(type: [String].self, forKey: .purchasedFilters)!
                for iap in removedIAPs {
                    purchasedFilters.removeAll(where: { $0 == iap })
                }
                UserDefaultsHelper.shared.setData(value: purchasedFilters, key: .purchasedFilters)
                
                // Reset to A
                selectedCollection = .aCollection
                
                DispatchQueue.main.async {
                    delegate?.filterListDidSelectCollection(.aCollection)
                    self.collectionView.reloadData()
                }
            })
            .sink { _ in }
            .store(in: &subscriptionsToken)
    }
}

extension FiltersCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersCollectionViewCell.ReuseIdentifier, for: indexPath) as! FiltersCollectionViewCell
        
        let item = filterCollections[indexPath.row]
        cell.filterCollection = item
        cell.isLocked = !UserDefaultsHelper.shared.getData(type: [String].self, forKey: .purchasedFilters)!.contains(where: { $0 == item.iapID })
        
        if item == selectedCollection {
            cell.isCellSelected = true
            initIndexPath = indexPath
        }
        
        cell.buttonTapped = {
            let vc = FilterInfoViewController()
            vc.selectedCollection = item
            
            vc.shouldRefreshCollectionView
                .handleEvents(receiveOutput: { [unowned self] shouldRefresh in
                    if shouldRefresh {
                        self.collectionView.reloadData()
                    }
                })
                .sink { _ in }
                .store(in: &self.subscriptionsToken)
            
            self.show(vc, sender: self)
        }
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? FiltersCollectionViewCell else { return }
        
        if !selectedCell.isLocked {
            if let initIndexPath = initIndexPath {
                if let cell = collectionView.cellForItem(at: initIndexPath) as? FiltersCollectionViewCell {
                    cell.isCellSelected = false
                }
                self.initIndexPath = nil
            }
            
            selectedCell.isCellSelected.toggle()
            delegate?.filterListDidSelectCollection(filterCollections[indexPath.row])
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        } else {
            TapticHelper.shared.errorTaptic()
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterCollections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterHeaderView.ReuseIdentifier, for: indexPath) as? FilterHeaderView {
            return headerView
        }
        return UICollectionReusableView()
    }
}

extension FiltersCollectionViewController {
    private func createSection() -> NSCollectionLayoutSection {
        let contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 20, trailing: 5)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = contentInsets
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInsets
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (_: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createSection()
        }
        
        // Configure the Layout with interSectionSpacing
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
}
