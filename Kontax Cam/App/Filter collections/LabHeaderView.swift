//
//  FilterHeaderView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FilterHeaderView: UICollectionReusableView {
    private let submissionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add submission", for: .normal)
        return button
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
        addSubview(submissionButton)
    }
    
    private func setupConstraint() {
        submissionButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
