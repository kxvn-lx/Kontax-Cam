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
    
    var availableExtraLens = [AVCaptureDevice?]() {
        didSet {
            setupExtraLensLabel()
        }
    }
    private let extraLensLabel: UILabel = {
        let label = UILabel()
        label.text = "1x"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    private var lensLabelArray = [String]()
    private var extraLensMultiplierArray = ["1x"]
    
    weak var delegate: ExtraLensViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
        
        // hidden by default
        self.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Update the lens appropriately
    func updateLensLabel() {
        extraLensLabel.text = getExtraLensString()
    }
    
    private func setupView() {
        addSubview(extraLensLabel)
        layer.cornerRadius = 17.5
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
    
    private func setupConstraint() {
        extraLensLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    private func setupExtraLensLabel() {
        for extraLens in availableExtraLens {
            if let availableLens = extraLens {
                self.isHidden = false
                if availableLens.deviceType == .builtInTelephotoCamera {
                    extraLensMultiplierArray.append("2x")
                } else if availableLens.deviceType == .builtInUltraWideCamera {
                    extraLensMultiplierArray.append("0.5x")
                }
            }
        }
    }
    
    private func getExtraLensString() -> String {
        if var currentIndex = extraLensMultiplierArray.firstIndex(of: extraLensLabel.text!) {
            currentIndex += 1
            return currentIndex >= extraLensMultiplierArray.count ? "1x" : extraLensMultiplierArray[currentIndex]
        } else {
            return extraLensMultiplierArray.first!
        }
    }
    
    @objc private func didTap() {
        self.delegate?.didTapOnExtraLensView()
    }
}
