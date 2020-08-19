//
//  FilterInfoViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 16/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FilterInfoViewController: UIViewController {
    
    private var viewModel: FilterInfoViewModel!
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    var selectedCollection: FilterCollection! {
        didSet {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle(selectedCollection.name)
        self.addCloseButton()
        self.view.backgroundColor = .systemBackground
        
        self.collectionView.register(FilterInfoCollectionViewCell.self, forCellWithReuseIdentifier: FilterInfoCollectionViewCell.ReuseIdentifier)
        
        viewModel = FilterInfoViewModel(collectionView: collectionView, filterCollection: selectedCollection)
        self.collectionView.delegate = viewModel
        
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        self.view.addSubview(collectionView)
    }
    
    private func setupConstraint() {
        collectionView.snp.makeConstraints { (make) in
            make.top.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
    }
}
