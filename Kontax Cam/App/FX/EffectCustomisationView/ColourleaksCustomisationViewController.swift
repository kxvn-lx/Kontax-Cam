//
//  ColourleaksCollectionViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 20/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ColourleaksCustomisationViewController: UIViewController {
    
    private let colourleaks = FilterValue.Colourleaks.ColourValue.allCases
    private let controlView = CustomisationControlHeaderView()
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        controlView.delegate = self
        
        self.collectionView!.register(ColourleaksCustomisationCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.configureNavigationBar(tintColor: .label, title: "Colour leaks", preferredLargeTitle: false, removeSeparator: true)
        self.view.backgroundColor = .systemBackground
        self.collectionView.backgroundColor = .clear
        
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        view.addSubview(controlView)
        view.addSubview(collectionView)
        
        controlView.controlTitleLabel.isHidden = true
        controlView.controlTitleLabel.removeFromSuperview()
    }
    
    private func setupConstraint() {
        controlView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.equalTo(self.view.frame.width * 0.85)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(115)
            make.centerX.equalToSuperview()
            make.top.equalTo(controlView.snp.bottom)
        }
        
        //        collectionView.snp.makeConstraints { (make) in
        //            make.edges.equalToSuperview()
        //        }
    }
    
    private func createSection(withHeader: Bool) -> NSCollectionLayoutSection {
        let contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = contentInsets
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.20),
            heightDimension: .fractionalWidth(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = contentInsets
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func makeLayout(withHeader: Bool = true) -> UICollectionViewLayout  {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createSection(withHeader: withHeader)
        }
        
        // Configure the Layout with interSectionSpacing
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
}

extension ColourleaksCustomisationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colourleaks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ColourleaksCustomisationCell
        
        let selectedValue = FilterValue.Colourleaks.selectedColourValue
        cell.colourView.backgroundColor = colourleaks[indexPath.row].displayValue
        if colourleaks[indexPath.row] == selectedValue {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            cell.isSelected = true
        }
        
        if colourleaks[indexPath.row] == FilterValue.Colourleaks.ColourValue.random {
            cell.colourView.image = IconHelper.shared.getIconImage(iconName: "shuffle")
            cell.colourView.backgroundColor = nil
            return cell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TapticHelper.shared.lightTaptic()
    }
}

extension ColourleaksCustomisationViewController: CustomisationControlProtocol {
    func didTapDone() {
        TapticHelper.shared.lightTaptic()
        let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first!
        
        FilterValue.Colourleaks.selectedColourValue = colourleaks[selectedIndexPath!.row]
        print("colour leaks new value: \(colourleaks[selectedIndexPath!.row].rawValue)")
        SPAlertHelper.shared.present(title: "Colour leaks set to: \(colourleaks[selectedIndexPath!.row].rawValue.capitalizingFirstLetter())")
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Custom cell class
class ColourleaksCustomisationCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                if let bg = self.colourView.backgroundColor {
                    self.wrappingView.layer.borderColor = bg.cgColor
                } else {
                    self.wrappingView.layer.borderColor = self.colourView.tintColor.cgColor
                }
            } else {
                self.wrappingView.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    let wrappingView: UIImageView = {
        let v = UIImageView()
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.clear.cgColor
        v.layer.cornerRadius = 40 / 2
        v.clipsToBounds = true
        return v
    }()
    let colourView: UIImageView = {
        let v = UIImageView()
        v.tintColor = .systemGray
        v.layer.cornerRadius = 30 / 2
        v.clipsToBounds = true
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(wrappingView)
        wrappingView.addSubview(colourView)
        
        wrappingView.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.center.equalToSuperview()
        }
        
        colourView.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

