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
    private let iapButton: DetailedButton = {
        let button = DetailedButton(title: "Purchase now")
        button.setTitle("Purchased", for: .disabled)
        button.backgroundColor = .black
        return button
    }()
    private let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore purchase", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .caption1)
        return button
    }()
    private var mStackView: UIStackView!
    
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
        
        // Disable button until IAP is implemented
        iapButton.isEnabled = false
    }
    
    private func setupView() {
        self.addVC(filterInfoImagesVC)
        
        mStackView = UIStackView(arrangedSubviews: [iapButton, restoreButton])
        mStackView.alignment = .center
        mStackView.axis = .vertical
        mStackView.spacing = 10
        
        self.view.addSubview(mStackView)
        
        iapButton.addTarget(self, action: #selector(iapButtonTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraint() {
        filterInfoImagesVC.view.snp.makeConstraints { (make) in
            make.top.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        iapButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        
        mStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalToSuperview().offset(-self.view.getSafeAreaInsets().bottom - 20)
        }
    }
    
    @objc private func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func iapButtonTapped() {

    }
    
    @objc private func restoreButtonTapped() {
        AlertHelper.shared.presentOKAction(
            withTitle: "Future feature!",
            andMessage: "This feature will comes with the addition of in app purchases. It will either be a one time purchase, or a subscription based. (help me decide?) 🤷‍♂️",
            to: self
        )
    }
}
