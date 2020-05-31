//
//  FXCollectionViewCell.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 29/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FXCollectionViewCell: UICollectionViewCell {
 
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
    
    let toggleLabel: UILabel = {
        let label = UILabel()
        label.text = "OFF"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption2).pointSize, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    var isFxSelected = false
    
    override func awakeFromNib() {
        self.addSubview(titleLabel)
        self.addSubview(toggleLabel)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemBackground.cgColor
        
        toggleLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview().inset(Constants.padding)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(toggleLabel).offset(-15)
            make.left.equalToSuperview().inset(Constants.padding)
        }
        
        updateStyle()
    }
    
    func toggleSelected() {
        isFxSelected = !isFxSelected
        updateStyle()
    }
    
    private func updateStyle() {
        updateElementStyle()
        toggleLabel.text = isFxSelected ? "ON" : "OFF"
    }
    
    private func updateElementStyle() {
        self.titleLabel.textColor = isFxSelected ? .label : .systemGray
        self.toggleLabel.textColor = isFxSelected ? .label : .systemGray
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                updateStyle()
            }
        }
    }
    
}
