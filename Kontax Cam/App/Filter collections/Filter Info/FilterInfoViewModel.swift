//
//  FilterInfoViewModel.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 18/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

struct FilterInfo: Hashable {
    let id = UUID()
    let image: UIImage?
    let filterName: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: FilterInfo, rhs: FilterInfo) -> Bool {
        return lhs.id == rhs.id
    }
}

class FilterInfoViewModel: NSObject {
    
    private let selectedFilterCollection: FilterCollection
    private weak var collectionView: UICollectionView?
    private var datasource: DataSource!
    private var datas = [FilterInfo]()
    
    init(collectionView: UICollectionView, filterCollection: FilterCollection) {
        self.selectedFilterCollection = filterCollection
        super.init()
        self.collectionView = collectionView
        
        collectionView.collectionViewLayout = createLayout()
        configureDatasource()
        setupDatas()
    }
    
    private func setupDatas() {
        let filterName = selectedFilterCollection.name.components(separatedBy: " ").first!
        for n in 1 ... 5 {
            let image = UIImage(named: "\(filterName).ex\(n)")
            
            let filterInfo = FilterInfo(image: image, filterName: "\(filterName)\(n)")
            datas.append(filterInfo)
        }
        
        self.createSnapshot(from: datas)
    }
}

extension FilterInfoViewModel {
    fileprivate enum Section { case main }
    fileprivate typealias DataSource = UICollectionViewDiffableDataSource<Section, FilterInfo>
    fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, FilterInfo>
    
    
    fileprivate func configureDatasource() {
        datasource = DataSource(collectionView: collectionView!, cellProvider: { (collectionView, indexPath, filterInfo) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterInfoCollectionViewCell.ReuseIdentifier, for: indexPath) as? FilterInfoCollectionViewCell else { return nil }
            
            cell.filterInfo = filterInfo
            
            return cell
        })
    }
    
    fileprivate func createSnapshot(from datas: [FilterInfo]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(datas)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension FilterInfoViewModel: UICollectionViewDelegate {
    
}
