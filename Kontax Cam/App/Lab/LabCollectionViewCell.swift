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
        v.layer.cornerRadius = 5
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        return v
    }()
    let dateLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .preferredFont(forTextStyle: .caption2)
        return v
    }()
    
    let infoSV = SVHelper.shared.createSV(axis: .horizontal, alignment: .center, distribution: .fillProportionally)
    let mSV = SVHelper.shared.createSV(axis: .vertical, alignment: .center, distribution: .fillProportionally)
    
    
    override func awakeFromNib() {
        self.addSubview(mSV)
        
        mSV.addArrangedSubview(photoView)
        mSV.addArrangedSubview(infoSV)
        
        photoView.snp.makeConstraints { (make) in
            make.height.width.equalTo(self.frame.size.width)
        }
        
        mSV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        infoSV.addArrangedSubview(dateLabel)
        
        infoSV.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
        }
    }
    
    
}
