//
//  ExtraLensView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 29/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import AVFoundation

protocol ExtraLensViewDelegate: class {
    func didTapOnExtraLensView()
}

class ExtraLensView: UIView {

    var availableExtraLens: AVCaptureDevice? {
        didSet {
            setupExtraLensLabel()
        }
    }
    private let extraLensLabel: UILabel = {
        let label = UILabel()
        label.text = "1x"
        label.textColor = .white
        return label
    }()
    private var lensLabelArray = [String]()
    private var extraLensMultiplierLabel = "-1x"
    var isShowingExtraLens = false {
        didSet {
            extraLensLabel.text = isShowingExtraLens ? extraLensMultiplierLabel : "1x"
        }
    }
    
    weak var delegate: ExtraLensViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(extraLensLabel)
        layer.cornerRadius = 22.5
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
    
    private func setupConstraint() {
        extraLensLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    private func setupExtraLensLabel() {
        if let availableLens = availableExtraLens {
            if availableLens.deviceType == .builtInTelephotoCamera {
                extraLensMultiplierLabel = "2x"
            } else if  availableLens.deviceType == .builtInUltraWideCamera {
                extraLensMultiplierLabel = "0.5x"
            }
            
        } else {
            self.isHidden = true
        }
        
    }
    
    @objc private func didTap() {
        self.delegate?.didTapOnExtraLensView()
    }
}
