//
//  FiltersCollectionViewCell.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 28/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FiltersCollectionViewCell: UICollectionViewCell {
    
    private struct Constants {
        static let padding = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    var isFilterSelected = false
    
    override func awakeFromNib() {
        self.addSubview(titleLabel)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(Constants.padding)
        }
        
        updateStyle()
    }
    
    func updateStyle() {
        self.layer.borderColor = isFilterSelected ? UIColor.label.cgColor : UIColor.clear.cgColor
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                updateStyle()
            }
        }
    }
}
