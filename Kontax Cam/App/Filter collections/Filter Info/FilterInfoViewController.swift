//
//  FilterInfoViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 16/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FilterInfoViewController: UIViewController {
    
    var selectedCollection: FilterCollection! {
        didSet {
            filterInfoImagesVC.selectedFilterCollection = selectedCollection
        }
    }
    private let filterInfoImagesVC = FilterInfoImagesCollectionViewController(collectionViewLayout: UICollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle(selectedCollection.name)
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .systemBackground
        
        setupView()
        setupConstraint()
        
        let closeButton = CloseButton()
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().inset(NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
        }
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func setupView() {
        self.addVC(filterInfoImagesVC)
    }
    
    private func setupConstraint() {
        filterInfoImagesVC.view.snp.makeConstraints { (make) in
            make.top.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    @objc private func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
