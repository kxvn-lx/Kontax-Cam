//
//  EmptyView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 30/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    private let backgroundView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "lab-placeholder")!
        v.contentMode = .scaleToFill
        return v
    }()
    private let iconImageView: UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        v.tintColor = .label
        return v
    }()
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Take or import your photos"
        lbl.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium)
        return lbl
    }()
    private let bodyLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = """
        Start by taking a photo or importing them from your camera roll.
        Imported photo will automatically be applied with the selected filter and effects.
        """
        lbl.font = .preferredFont(forTextStyle: .caption1)
        lbl.numberOfLines = 0
        return lbl
    }()
    private var mSV: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    private func setupUI() {
        self.addSubview(backgroundView)
        iconImageView.image = IconHelper.shared.getIconImage(iconName: "plus.circle")
        
        // setup stackview
        mSV = SVHelper.shared.createSV(axis: .vertical, alignment: .leading, distribution: .fillProportionally)
        mSV.addArrangedSubview(iconImageView)
        mSV.addArrangedSubview(titleLabel)
        mSV.addArrangedSubview(bodyLabel)
        
        backgroundView.addSubview(mSV)
    }
    
    private func setupConstraint() {
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        mSV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-80)
            make.width.equalTo(self.frame.width * 0.9)
        }
    }
    
}
