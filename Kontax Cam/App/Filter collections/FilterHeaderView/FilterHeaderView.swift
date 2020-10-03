//
//  FilterHeaderView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 3/10/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI
import UIKit

// MARK: - Header view
class FilterHeaderView: UICollectionReusableView {
    static let ReuseIdentifier = "FilterHeaderView"
    
    private let fHeaderView = UIHostingController(rootView: FHeaderView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(fHeaderView.view)
    }
    
    private func setupConstraint() {
        fHeaderView.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
