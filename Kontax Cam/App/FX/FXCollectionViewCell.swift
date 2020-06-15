//
//  FXCollectionViewCell.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 29/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FXCollectionViewCell: UICollectionViewCell {

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
        label.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption2).pointSize, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    var isFxSelected = false
    
    override func awakeFromNib() {
        self.addSubview(titleLabel)
        self.addSubview(toggleLabel)
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 5
        self.layer.cornerCurve = .continuous
        
        toggleLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(toggleLabel).offset(-15)
            make.left.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0))
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
        self.titleLabel.textColor = isFxSelected ? .label : .systemGray4
        self.toggleLabel.textColor = isFxSelected ? .label : .systemGray4
        
        self.backgroundColor = isFxSelected ? .systemGray5 : UIColor.secondarySystemBackground.withAlphaComponent(0.2)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                updateStyle()
            }
        }
    }
    
}
