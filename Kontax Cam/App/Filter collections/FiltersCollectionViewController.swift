//
//  FiltersCollectionViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 28/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import PanModal

protocol FilterListDelegate: class {
    /// Tells the delegate that a filter collection has been selected
    func filterListDidSelectCollection(_ collection: FilterCollection)
}

class FiltersCollectionViewController: UICollectionViewController {
    
    var filterCollections = [FilterCollection]()
    var selectedCollection = FilterCollection.aCollection
    weak var delegate: FilterListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle("Filter collections")
        self.collectionView.backgroundColor = .systemBackground
        
        // 1. Setup the layout
        collectionView.collectionViewLayout = makeLayout()
        collectionView.register(FiltersCollectionViewCell.self, forCellWithReuseIdentifier: FiltersCollectionViewCell.ReuseIdentifier)
        
        // 2. Setup datasource
        self.populateSection()
        
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(infoButtonTapped))
        self.navigationItem.rightBarButtonItem = infoButton
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterCollections.count
    }
    
    @objc private func infoButtonTapped() {
        AlertHelper.shared.presentOKAction(withTitle: "#TakenWithKontaxCam", andMessage: "Send your photos taken with Kontax Cam via email if you wished to be featured on the collection's cover page.", to: self)
    }
}

// MARK: - CollectionView delegate
extension FiltersCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersCollectionViewCell.ReuseIdentifier, for: indexPath) as! FiltersCollectionViewCell
        
        let item = filterCollections[indexPath.row]
        cell.collectionNameLabel.text = item.name
        cell.imageView.image = item.image
        
        cell.isSelected = item == selectedCollection
        
        cell.buttonTapped = {
            AlertHelper.shared.presentOKAction(withTitle: "Future feature!", andMessage: "This feature will allow you to see all the filters inside this collection, along with sample images.", to: self)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterListDidSelectCollection(filterCollections[indexPath.row])
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension FiltersCollectionViewController {
    private func createSection() -> NSCollectionLayoutSection {
        let contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = contentInsets
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInsets
        
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

extension FiltersCollectionViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return collectionView
    }
}
