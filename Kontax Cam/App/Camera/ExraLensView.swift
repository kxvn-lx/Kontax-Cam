//
//  ExtraLensView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 29/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class ExtraLensView: UIView {

    private let extraLensLabel: UILabel = {
        let label = UILabel()
        label.text = "2x"
        label.backgroundColor = .red
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
        addSubview(extraLensLabel)
    }
    
    private func setupConstraint() {
        extraLensLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
