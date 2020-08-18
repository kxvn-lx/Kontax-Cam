//
//  FilterInfoViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 16/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FilterInfoViewController: UICollectionViewController {
    
    private var viewModel: FilterInfoViewModel!
    var selectedCollection: FilterCollection! {
        didSet {

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle("")
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .systemBackground
        
        self.collectionView.register(FilterInfoCollectionViewCell.self, forCellWithReuseIdentifier: FilterInfoCollectionViewCell.ReuseIdentifier)
        
        viewModel = FilterInfoViewModel(owner: self, filterCollection: selectedCollection)
        self.collectionView.delegate = viewModel
        
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        self.collectionView.backgroundColor = .systemBackground
    }
    
    private func setupConstraint() {

    }
}
