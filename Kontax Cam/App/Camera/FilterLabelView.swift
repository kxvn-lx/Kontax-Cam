//
//  FilterLabelView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 9/7/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FilterLabelView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "OFF"
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.layer.cornerRadius = 5
        blurredEffectView.layer.cornerCurve = .continuous
        blurredEffectView.layer.masksToBounds = true
        return blurredEffectView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Class methods
    private func setupView() {
        addSubview(blurEffectView)
        addSubview(titleLabel)
    }
    
    private func setupConstraint() {
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        blurEffectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
