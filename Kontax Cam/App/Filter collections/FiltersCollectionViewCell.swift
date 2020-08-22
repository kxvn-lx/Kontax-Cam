//
//  FiltersCollectionViewCell.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 28/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FiltersCollectionViewCell: UICollectionViewCell {
    
    static let ReuseIdentifier = "filtersCell"
    
    private struct Constants {
        static let padding = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    private var cache = NSCache<NSString, UIImage>()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let collectionNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let infoButton: UIButton = {
        let button = UIButton(type: .detailDisclosure)
        button.tintColor = UIColor.label.withAlphaComponent(0.5)
        return button
    }()
    private let nameLabelView: UIView = {
        let view = UIView()
        return view
    }()
    
    var buttonTapped: (() -> Void)? = nil
    var filterCollection: FilterCollection! {
        didSet {
            collectionNameLabel.text = filterCollection.name
        }
    }
    
    override var isSelected: Bool {
        didSet {
            setCellSelected()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
        layer.borderColor = UIColor.label.cgColor
        layer.cornerRadius = 5
        layer.cornerCurve = .continuous
        clipsToBounds = true
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let cachedImage = cache.object(forKey: Self.ReuseIdentifier as NSString) {
            imageView.image = cachedImage
        } else {
            if let resizedImage = filterCollection.image!.scaleImage(width: imageView.bounds.size.width, height: imageView.bounds.size.height, trim: true) {
                imageView.image = resizedImage
                cache.setObject(resizedImage, forKey: Self.ReuseIdentifier as NSString)
            }
        }

    }
    
    private func setupView() {
        nameLabelView.addSubview(collectionNameLabel)
        nameLabelView.addSubview(infoButton)
        
        addSubview(imageView)
        addSubview(nameLabelView)
        
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
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
    
    @objc private func infoButtonTapped() {
        if let buttonAction = buttonTapped {
            buttonAction()
        }
    }

}
