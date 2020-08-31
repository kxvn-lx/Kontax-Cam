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
            titleLabel.text = selectedCollection.name
        }
    }
    private let filterInfoImagesVC = FilterInfoImagesCollectionViewController(collectionViewLayout: UICollectionViewLayout())
    private let iapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Purchased", for: .disabled)
        button.setTitle("$5.99", for: .normal)
        button.tintColor = .label
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    private let spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.color = .label
        spinner.isHidden = false
        return spinner
    }()
    private var mStackView: UIStackView!
    
    private var shouldShowSpinner = false {
        didSet {
            spinnerView.isHidden = !shouldShowSpinner
            iapButton.isHidden = shouldShowSpinner
        }
    }
    
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
        
        shouldShowSpinner = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.shouldShowSpinner = false
        }
    }
    
    private func setupView() {
        self.addVC(filterInfoImagesVC)
        self.view.addSubview(titleLabel)
        
        mStackView = UIStackView(arrangedSubviews: [spinnerView, iapButton])
        mStackView.alignment = .center
        
        self.view.addSubview(mStackView)
        
        iapButton.addTarget(self, action: #selector(iapButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraint() {
        filterInfoImagesVC.view.snp.makeConstraints { (make) in
            make.top.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(filterInfoImagesVC.view.snp.bottom).offset(30)
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
        AlertHelper.shared.presentOKAction(
            withTitle: "Future feature!",
            andMessage: "This feature will come with the addition of in app purchases. It will either be a one time purchase, or a subscription based. (help me decide?) 🤷‍♂️",
            to: self
        )
    }
}
