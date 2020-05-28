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
    
    override func awakeFromNib() {
        self.addSubview(titleLabel)
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(Constants.padding)
        }
    }
}
