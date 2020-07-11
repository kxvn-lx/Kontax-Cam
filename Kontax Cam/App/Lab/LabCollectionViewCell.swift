//
//  LabCollectionViewCell.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 25/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class LabCollectionViewCell: UICollectionViewCell {
    
    let photoView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    private var isUserSelected = false
    private let borderWidth: CGFloat = 2
    private let duration: Double = 0.0625
    
    static let reuseIdentifier = "labCell"
    
    override func awakeFromNib() {
        self.addSubview(photoView)
        
        self.layer.borderColor = UIColor.label.cgColor
        self.layer.borderWidth = 0
        
        photoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isUserSelected = false
        toggleSelection(override: true)
    }
    
    func toggleSelection(override: Bool = false) {
        if override {
            self.layer.borderWidth = 0
            return
        }
        
        isUserSelected.toggle()
        
        if isUserSelected {
            let animation = CABasicAnimation(keyPath: "borderWidth")
            animation.fromValue = self.layer.borderWidth
            animation.toValue = borderWidth
            animation.duration = duration
            
            self.layer.add(animation, forKey: "width")
            self.layer.borderWidth = borderWidth

        } else {
            let animation = CABasicAnimation(keyPath: "borderWidth")
            animation.fromValue = borderWidth
            animation.toValue = 0
            animation.duration = duration
            
            self.layer.add(animation, forKey: "width")
            self.layer.borderWidth = 0
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.layer.borderColor = UIColor.label.cgColor
    }
}
