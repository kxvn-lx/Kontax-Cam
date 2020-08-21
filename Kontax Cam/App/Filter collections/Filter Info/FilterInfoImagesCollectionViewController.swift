//
//  FilterInfoImagesCollectionViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 21/8/20.
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

class FilterInfoImagesCollectionViewController: UICollectionViewController {

    var selectedFilterCollection: FilterCollection!
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 5 // Hardcoded since we know there will only be 5 example images
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = .systemGray5
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    private var datasource: DataSource!
    private var datas = [FilterInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.alwaysBounceVertical = false
        collectionView.isPagingEnabled = true
        collectionView.register(FilterInfoCollectionViewCell.self, forCellWithReuseIdentifier: FilterInfoCollectionViewCell.ReuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
        
        configureDatasource()
        setupDatas()
        
        setupView()
        setupConstraint()
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
    
    private func setupView() {
        self.view.addSubview(pageControl)
    }
    
    private func setupConstraint() {
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func pageControlDidChange(sender: UIPageControl) {
        collectionView.scrollToItem(at: IndexPath(row: sender.currentPage, section: 0), at: .centeredVertically, animated: true)
    }
}

extension FilterInfoImagesCollectionViewController {
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
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.925))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, _, _ in
            self?.pageControl.currentPage = visibleItems.last!.indexPath.row
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
