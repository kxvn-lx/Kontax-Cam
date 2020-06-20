//
//  CustomisationControlHeaderView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 21/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

protocol CustomisationControlProtocol: class {
    func didTapOk()
}

class CustomisationControlHeaderView: UIView {

    let controlTitleLabel: UILabel = {
       let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .label
        v.textAlignment = .left
        v.text = "Strength: +10.0"
        v.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize, weight: .medium)
        return v
    }()
    let okButton: UIButton = {
        let v = UIButton()
        v.setTitle("Done", for: .normal)
        v.tintColor = .label
        return v
    }()
    
    weak var delegate: CustomisationControlProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(controlTitleLabel)
        addSubview(okButton)
        
        controlTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        okButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func okTapped() {
        delegate?.didTapOk()
    }
    
}
