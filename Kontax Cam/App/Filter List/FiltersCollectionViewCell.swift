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
    
    let imageView1: UIImageView = {
        let imageView1 = UIImageView()
        imageView1.backgroundColor = .orange
        return imageView1
    }()
    let imageView2: UIImageView = {
        let imageView2 = UIImageView()
        imageView2.backgroundColor = .orange
        return imageView2
    }()
    let imageView3: UIImageView = {
        let imageView3 = UIImageView()
        imageView3.backgroundColor = .orange
        return imageView3
    }()
    let collectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    let infoButton: UIButton = {
        let button = UIButton(type: .detailDisclosure)
        button.tintColor = UIColor.label.withAlphaComponent(0.5)
        return button
    }()
    let mSV: UIStackView = {
        return SVHelper.shared.createSV(axis: .horizontal, alignment: .center, distribution: .equalSpacing)
    }()
    let nameLabelView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func awakeFromNib() {
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        mSV.addArrangedSubview(imageView1)
        mSV.addArrangedSubview(imageView2)
        mSV.addArrangedSubview(imageView3)
        
        nameLabelView.addSubview(collectionNameLabel)
        nameLabelView.addSubview(infoButton)
        
        addSubview(mSV)
        addSubview(nameLabelView)
    }
    
    private func setupConstraint() {
        mSV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        mSV.arrangedSubviews.forEach({
            $0.snp.makeConstraints { (make) in
                make.height.equalTo(100)
                make.width.equalTo(90)
            }
        })
        
        nameLabelView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
        
        collectionNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(21)
        }
        
        infoButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-21)
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            
        }
    }
}
