//
//  FXCollectionViewCell.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 29/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FXCollectionViewCell: UICollectionViewCell {

    static let ReuseIdentifier = "FxCell"
    
    let isActiveView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 5, height: 5)))
        view.isHidden = true
        view.layer.cornerRadius = view.frame.size.height / 2
        view.backgroundColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    let iconImageView: UIImageView = {
        let v = UIImageView()
        v.tintColor = .label
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    var isFxSelected = false {
        didSet {
            isActiveView.isHidden = !isFxSelected
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
        isFxSelected = false
    }
    
    private func setupView() {
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(isActiveView)
    }
    
    private func setupConstraint() {
        iconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.frame.width * 0.225)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(7.5)
        }
        
        isActiveView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(5)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
}
