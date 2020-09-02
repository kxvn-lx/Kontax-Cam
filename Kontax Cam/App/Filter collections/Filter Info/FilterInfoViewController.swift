//
//  FilterInfoViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 16/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import Combine

class FilterInfoViewController: UIViewController {
    
    var shouldRefreshCollectionView = PassthroughSubject<Bool, Never>()
    
    var selectedCollection: FilterCollection! {
        didSet {
            filterInfoImagesVC.selectedFilterCollection = selectedCollection
            titleLabel.text = selectedCollection.name
            
            selectedCollectionIAP = IAPManager.shared.inAppPurchases.filter({ $0.title == selectedCollection.name }).first
        }
    }
    private var selectedCollectionIAP: InAppPurchase? {
        didSet {
            if let iap = selectedCollectionIAP {
                iapButton.setTitle(iap.price, for: .normal)
            }
        }
    }
    private var subscriptions = Set<AnyCancellable>()
    
    private let filterInfoImagesVC = FilterInfoImagesCollectionViewController(collectionViewLayout: UICollectionViewLayout())
    private let iapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Purchased", for: .disabled)
        button.setTitle("$-1", for: .normal)
        button.tintColor = .label
        return button
    }()
    private let successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconHelper.shared.getIconImage(iconName: "checkmark.circle.fill")
        imageView.tintColor = .systemGreen
        imageView.isHidden = true
        imageView.alpha = 0
        return imageView
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
        
        spinnerSetup()
        observeIAP()
    }
    
    private func setupView() {
        self.addVC(filterInfoImagesVC)
        self.view.addSubview(titleLabel)
        
        mStackView = UIStackView(arrangedSubviews: [spinnerView, iapButton, successImageView])
        mStackView.axis = .vertical
        mStackView.alignment = .center
        
        self.view.addSubview(mStackView)
        
        iapButton.addTarget(self, action: #selector(iapButtonTapped), for: .touchUpInside)
        
        let purchasedFilters = UserDefaultsHelper.shared.getData(type: [String].self, forKey: .purchasedFilters)!
        if purchasedFilters.contains(selectedCollection.iapID) || selectedCollectionIAP == nil {
            // User has bought the collection
            mStackView.isHidden = true
        }
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
        
        successImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(35)
        }
    }
    
    /// Observe IAP changes in real time.
    private func observeIAP() {
        // Observed for live-change on IAP events
        IAPManager.shared.removedIAPs
            .handleEvents(receiveOutput: { [unowned self] removedIAPs in
                if let selectedCollectionIAP = selectedCollectionIAP {
                    let iapID = IAPManager.shared.bundleID + "." + selectedCollectionIAP.registeredPurchase.suffix
                    
                    DispatchQueue.main.async {
                        if removedIAPs.contains(iapID) && mStackView.isHidden {
                            mStackView.isHidden = false
                            
                            var purchasedFilters = UserDefaultsHelper.shared.getData(type: [String].self, forKey: .purchasedFilters)!
                            purchasedFilters.removeAll(where: { $0 == selectedCollectionIAP.title })
                            UserDefaultsHelper.shared.setData(value: purchasedFilters, key: .purchasedFilters)
                        }
                    }
                }
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
    
    /// Determine how the spinner will be shown
    private func spinnerSetup() {
        shouldShowSpinner = true
        
        if !ReachabilityHelper.shared.isConnectedToNetwork() && selectedCollection != .aCollection {
            AlertHelper.shared.presentOKAction(
                andMessage: "No internet connection. Please try again later",
                to: self
            )
            spinnerView.isHidden = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.shouldShowSpinner = false
            }
        }
    }
    
    private func startIAPSuccessAnimation() {
        let duration: Double = 0.5
        
        UIView.animate(withDuration: duration) {
            self.iapButton.isHidden = true
            self.iapButton.alpha = 0
            
            self.successImageView.isHidden = false
            self.successImageView.alpha = 1
        } completion: { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: duration) {
                    self.successImageView.alpha = 0
                } completion: { (_) in
                    self.mStackView.isHidden = true
                    self.iapButton.isHidden = false
                    self.iapButton.alpha = 1
                    self.successImageView.isHidden = true
                }
            }
        }
    }
    
    @objc private func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func iapButtonTapped() {
        guard let selectedCollectionIAP = selectedCollectionIAP else {
            AlertHelper.shared.presentOKAction(
                withTitle: "Oops!",
                andMessage: "Looks like there was a problem purchasing this collection. Please try again.",
                to: self
            )
            return
        }
        
        IAPManager.shared.purchase(selectedCollectionIAP.registeredPurchase.suffix) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let purchaseDetails):
                if IAPManager.isDebugMode {
                    print("Purchase detail: \(purchaseDetails)")
                }
                
                var purchasedFilters = UserDefaultsHelper.shared.getData(type: [String].self, forKey: .purchasedFilters)!
                if !purchasedFilters.contains(selectedCollectionIAP.id) {
                    purchasedFilters.append(selectedCollectionIAP.id)
                }
                
                UserDefaultsHelper.shared.setData(value: purchasedFilters, key: .purchasedFilters)
                self.startIAPSuccessAnimation()
                
                self.shouldRefreshCollectionView.send(true)
                
            case .failure(let error):
                
                switch error.code {
                case .paymentCancelled:
                    break
                default:
                    AlertHelper.shared.presentOKAction(
                        withTitle: "Oops!",
                        andMessage: error.localizedDescription,
                        to: self
                    )
                }
            }
        }
    }
}
