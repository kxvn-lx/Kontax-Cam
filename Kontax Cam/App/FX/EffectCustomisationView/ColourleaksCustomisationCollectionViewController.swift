//
//  ColourleaksCollectionViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 20/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ColourleaksCustomisationCollectionViewController: UICollectionViewController {
    
    private let colourleaks = FilterValue.Colourleaks.ColourValue.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(ColourleaksCustomisationCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.configureNavigationBar(tintColor: .label, title: "Colour leaks", preferredLargeTitle: false, removeSeparator: true)
        self.collectionView.backgroundColor = .systemBackground
        
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colourleaks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ColourleaksCustomisationCell
        cell.colourView.backgroundColor = colourleaks[indexPath.row].displayValue
        cell.titleLabel.text = colourleaks[indexPath.row].rawValue.capitalizingFirstLetter()
        
        let selectedValue = FilterValue.Colourleaks.selectedColourValue
        cell.colourView.layer.borderWidth = selectedValue.rawValue == colourleaks[indexPath.row].rawValue ? 2 : 0
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TapticHelper.shared.mediumTaptic()
        
        FilterValue.Colourleaks.selectedColourValue = colourleaks[indexPath.row]
        print("colour leaks new value: \(colourleaks[indexPath.row].rawValue)")
        SPAlertHelper.shared.present(title: "Colour leaks set to: \(colourleaks[indexPath.row].rawValue.capitalizingFirstLetter())")
        dismiss(animated: true, completion: nil)
    }
}

class ColourleaksCustomisationCell: UICollectionViewCell {
    
    let colourView: UIView = {
        let v = UIView()
        v.layer.borderColor = UIColor.label.cgColor
        v.layer.borderWidth = 0
        v.layer.cornerRadius = 10
        v.layer.cornerCurve = .continuous
        v.clipsToBounds = true
        return v
    }()
    let titleLabel: UILabel = {
        let v = UILabel()
        v.font = .preferredFont(forTextStyle: .caption1)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(colourView)
        addSubview(titleLabel)
        
        colourView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.frame.width * 0.8)
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(colourView.snp.bottom).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.colourView.layer.borderColor = UIColor.label.cgColor
    }
    
}

