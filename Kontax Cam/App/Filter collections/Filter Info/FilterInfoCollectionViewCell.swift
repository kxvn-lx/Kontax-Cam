//
//  FilterInfoCollectionViewCell.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 18/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FilterInfoCollectionViewCell: UICollectionViewCell {
    
    private let cache = NSCache<NSString, UIImage>()
    static let ReuseIdentifier = "FilterInfoCell"
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    var filterInfo: FilterInfo!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let cachedImage = cache.object(forKey: filterInfo.image!.accessibilityIdentifier! as NSString) {
            imageView.image = cachedImage
        } else {
            if let resizedImage = filterInfo.image!.scaleImage(width: imageView.bounds.size.width, height: imageView.bounds.size.height, trim: true) {
                imageView.image = resizedImage
                self.cache.setObject(resizedImage, forKey: filterInfo.image!.accessibilityIdentifier! as NSString)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setupView() {
        self.addSubview(imageView)
    }
    
    private func setupConstraint() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
