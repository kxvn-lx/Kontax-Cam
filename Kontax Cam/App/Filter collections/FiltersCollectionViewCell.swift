//
//  FiltersCollectionViewCell.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 28/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class FiltersCollectionViewCell: UICollectionViewCell {
    
    static let ReuseIdentifier = "filtersCell"
    
    private struct Constants {
        static let padding = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.cornerCurve = .continuous
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.large
        imageView.sd_imageTransition = .fade
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
    private var mStackView: UIStackView!
    
    var buttonTapped: (() -> Void)?
    var filterCollection: FilterCollection! {
        didSet {
            collectionNameLabel.text = filterCollection.name
            imageView.sd_setImage(with: URL(string: filterCollection.imageURL)!, placeholderImage: UIImage(named: "collection-placeholder"), options: .scaleDownLargeImages)
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

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }
    
    private func setupView() {
        nameLabelView.addSubview(collectionNameLabel)
        nameLabelView.addSubview(infoButton)
        
        mStackView = UIStackView(arrangedSubviews: [imageView, nameLabelView])
        mStackView.axis = .vertical
        mStackView.spacing = 10
        
        addSubview(mStackView)
        
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraint() {
        imageView.snp.makeConstraints { (make) in
            make.height.equalTo(self.bounds.height * 0.75)
        }
        
        mStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        
//        nameLabelView.snp.makeConstraints { (make) in
//            make.width.equalToSuperview()
//            make.height.equalTo(50)
//            make.bottom.equalToSuperview()
//        }
//
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
