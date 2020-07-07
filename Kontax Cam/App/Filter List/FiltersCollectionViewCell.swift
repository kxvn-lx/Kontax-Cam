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
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let collectionNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let infoButton: UIButton = {
        let button = UIButton(type: .detailDisclosure)
        button.tintColor = UIColor.label.withAlphaComponent(0.5)
        return button
    }()
    let nameLabelView: UIView = {
        let view = UIView()
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            setCellSelected()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupConstraint()
        layer.borderColor = UIColor.label.cgColor
        
        // Setup blur view
        nameLabelView.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        nameLabelView.insertSubview(blurView, at: 0)
        
        blurView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }
    
    private func setupView() {
        nameLabelView.addSubview(collectionNameLabel)
        nameLabelView.addSubview(infoButton)
        
        addSubview(imageView)
        addSubview(nameLabelView)
    }
    
    private func setupConstraint() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
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
    
    /// Gives a selected cell a style.
    private func setCellSelected() {
        layer.borderWidth = isSelected ? 2 : 0
        collectionNameLabel.font = .preferredFont(forTextStyle: isSelected ? .headline : .body)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            layer.borderColor = UIColor.label.cgColor
        }
    }
}
