//
//  FilterInfoViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 16/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import Combine
import Backend

struct FilterInfo: Hashable {
    let id = UUID()
    let imageURL: URL
    let filterName: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FilterInfo, rhs: FilterInfo) -> Bool {
        return lhs.id == rhs.id
    }
}

class FilterInfoViewController: UIViewController {
    
    var shouldRefreshCollectionView = PassthroughSubject<Bool, Never>()
    
    var selectedCollection: FilterCollection! {
        didSet {
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
    private var subscriptionsToken = Set<AnyCancellable>()
    
    private let iapButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5
        button.layer.cornerCurve = .continuous
        button.backgroundColor = UIColor(named: "DetailedButtonColor")
        button.contentEdgeInsets = UIEdgeInsets(top: 7.5, left: 20, bottom: 7.5, right: 20)
        button.setTitle("Purchased".localized, for: .disabled)
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
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.alwaysBounceHorizontal = true
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
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
    private var shouldShowSpinner = false {
        didSet {
            spinnerView.isHidden = !shouldShowSpinner
            iapButton.isHidden = shouldShowSpinner
        }
    }
    private let purchasedFilters = UserDefaultsHelper.shared.getData(type: [String].self, forKey: .purchasedFilters)!
    
    private var tryButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Setup try button
        tryButton = UIBarButtonItem(title: "Try".localized, style: .plain, target: self, action: #selector(tryButtonTapped))
        navigationItem.rightBarButtonItem = tryButton
        tryButton.isHidden = purchasedFilters.contains(selectedCollection.iapID)
        
        // Setup collectionview
        collectionView.register(FilterInfoCollectionViewCell.self, forCellWithReuseIdentifier: FilterInfoCollectionViewCell.ReuseIdentifier)
        collectionView.collectionViewLayout = createLayout()
        configureDatasource()
        setupImageDatas()
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
        self.view.backgroundColor = .systemBackground
        
        setupView()
        setupConstraint()
        
        spinnerSetup()
        observeIAP()
    }
    
    /// Setup datas for collectionview images
    private func setupImageDatas() {
        let filterName = selectedCollection.name.components(separatedBy: " ").first!
        
        for n in 1 ... 5 {
            let imageURL = URL(string: "https://kontaxcam.imfast.io/\(filterName)/\(filterName).ex\(n).jpg")!
            
            let filterInfo = FilterInfo(imageURL: imageURL, filterName: "\(filterName)\(n)")
            datas.append(filterInfo)
        }
        
        self.createSnapshot(from: datas)
    }
    
    private func setupView() {
        self.view.addSubview(collectionView)
        self.view.addSubview(pageControl)
        self.view.addSubview(titleLabel)
        
        mStackView = UIStackView(arrangedSubviews: [spinnerView, iapButton, successImageView])
        mStackView.axis = .vertical
        mStackView.alignment = .center
        
        self.view.addSubview(mStackView)
        
        iapButton.addTarget(self, action: #selector(iapButtonTapped), for: .touchUpInside)
        
        if selectedCollection == FilterCollection.aCollection {
            mStackView.isHidden = true
            return
        }
        
        if purchasedFilters.contains(selectedCollection.iapID) || selectedCollectionIAP == nil {
            // User has bought the collection
            iapButton.isEnabled = false
            iapButton.setTitle("Purchased".localized, for: .disabled)
        }
    }
    
    private func setupConstraint() {
        collectionView.snp.makeConstraints { (make) in
            make.top.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(5)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(pageControl.snp.bottom).offset(32.5)
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
    
    @objc private func pageControlDidChange(sender: UIPageControl) {
        collectionView.scrollToItem(at: IndexPath(row: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    /// Observe IAP changes in real time.
    private func observeIAP() {
        // Observed for live-change on IAP events
        IAPManager.shared.removedIAPs
            .handleEvents(receiveOutput: { [unowned self] removedIAPs in
                if let selectedCollectionIAP = selectedCollectionIAP {
                    let iapID = IAPManager.shared.bundleID + "." + selectedCollectionIAP.registeredPurchase.suffix
                    
                    DispatchQueue.main.async {
                        if removedIAPs.contains(iapID) && iapButton.isEnabled == false {
                            iapButton.isEnabled = true
                            tryButton.isHidden = false
                            
                            var purchasedFilters = UserDefaultsHelper.shared.getData(type: [String].self, forKey: .purchasedFilters)!
                            purchasedFilters.removeAll(where: { $0 == selectedCollectionIAP.title })
                            UserDefaultsHelper.shared.setData(value: purchasedFilters, key: .purchasedFilters)
                        }
                    }
                }
            })
            .sink { _ in }
            .store(in: &subscriptionsToken)
    }
    
    /// Determine how the spinner will be shown
    private func spinnerSetup() {
        shouldShowSpinner = true
        
        if !ReachabilityHelper.shared.isConnectedToNetwork() && selectedCollection != .aCollection {
            iapButton.isEnabled = false
            iapButton.setTitle("No internet connection.", for: .disabled)
            spinnerView.isHidden = true
            self.shouldShowSpinner = false
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.25...0.75)) {
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
            self.iapButton.isEnabled = false
            self.iapButton.setTitle("Purchased", for: .disabled)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: duration) {
                    self.successImageView.alpha = 0
                    self.successImageView.isHidden = true
                    
                    self.iapButton.isHidden = false
                    self.iapButton.alpha = 1
                }
            }
        }
    }
    
    @objc private func iapButtonTapped() {
        let window = UIApplication.shared.keyWindow!
        let loadingVC = LoadingViewController()
        loadingVC.shouldHideTitleLabel = true
        
        window.addSubview(loadingVC.view)
        
        // Make sure we have an IAP to purchase
        guard let selectedCollectionIAP = selectedCollectionIAP else {
            AlertHelper.shared.presentOKAction(
                withTitle: "Oops!",
                andMessage: "Looks like there was a problem purchasing this collection. Please try again.",
                to: self
            )
            loadingVC.view.removeFromSuperview()
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
                TapticHelper.shared.successTaptic()
                self.tryButton.isHidden = true
                
                self.shouldRefreshCollectionView.send(true)
                
                loadingVC.view.removeFromSuperview()
                
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
                loadingVC.view.removeFromSuperview()
                
            }
        }
    }
    
    @objc private func tryButtonTapped() {
        let tryVC = TryViewController()
        tryVC.currentCollection = selectedCollection
        tryVC.modalPresentationStyle = .overFullScreen
        self.present(tryVC, animated: true, completion: nil)
    }
}

extension FilterInfoViewController {
    fileprivate enum Section { case main }
    fileprivate typealias DataSource = UICollectionViewDiffableDataSource<Section, FilterInfo>
    fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, FilterInfo>
    
    fileprivate func configureDatasource() {
        datasource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, filterInfo) -> UICollectionViewCell? in
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
            heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, _, _ in
            self?.pageControl.currentPage = visibleItems.last!.indexPath.row
        }
        section.interGroupSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
