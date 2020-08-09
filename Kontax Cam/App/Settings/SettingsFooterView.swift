//
//  SettingsFooterView.swift
//  Ghibliii
//
//  Created by Kevin Laminto on 4/8/20.
//

import UIKit

class SettingsFooterView: UIView {
    
    private var mStackView: UIStackView!
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appIcon-ori")
        imageView.layer.cornerRadius = 18.75
        imageView.clipsToBounds = true
        imageView.layer.cornerCurve = .continuous
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray5.cgColor
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Kontax Cam"
        label.textColor = .label
        label.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize, weight: .bold)
        return label
    }()
    private let appVersionLabel: UILabel = {
        let label = UILabel()
        label.text = UIApplication.appVersion
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .callout).pointSize, weight: .medium)
        return label
    }()
    private let createdByLabel: UILabel = {
        let label = UILabel()
        label.text = "Made with ❤️ by Kevin Laminto\nin Melbourne, Australia 🇦🇺"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        mStackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, appVersionLabel, createdByLabel])
        mStackView.isLayoutMarginsRelativeArrangement = true
        mStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        mStackView.axis = .vertical
        mStackView.alignment = .center
        
        mStackView.setCustomSpacing(10, after: iconImageView)
        mStackView.setCustomSpacing(10, after: appVersionLabel)
        
        addSubview(mStackView)
    }
    
    private func setupConstraint() {
        iconImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(75)
        }
        
        mStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        iconImageView.layer.borderColor = UIColor.systemGray5.cgColor
    }
}
