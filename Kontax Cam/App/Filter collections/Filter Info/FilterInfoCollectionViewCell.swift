//
//  FilterInfoCollectionViewCell.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 18/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class FilterInfoCollectionViewCell: UICollectionViewCell {
    
    static let ReuseIdentifier = "FilterInfoCell"
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.large
        imageView.sd_imageTransition = .fade
        return imageView
    }()
    var filterInfo: FilterInfo! {
        didSet {
            imageView.sd_setImage(with: filterInfo.imageURL, placeholderImage: UIImage(named: "labCellPlaceholder"), options: .scaleDownLargeImages)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
}
