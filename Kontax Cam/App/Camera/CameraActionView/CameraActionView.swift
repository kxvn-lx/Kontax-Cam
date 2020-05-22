//
//  CameraActionView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SnapKit
import CameraManager
import SPAlert

class CameraActionView: UIView {
    
    private var cameraActionStack = SVHelper.shared.createSV(axis: .vertical, spacing: 40, alignment: .center, distribution: .fillProportionally)
    private var functionStack = SVHelper.shared.createSV(axis: .horizontal, alignment: .center, distribution: .equalCentering)
    
    private let flashButton = UIButton()
    private let timerButton = UIButton()
    private let reverseCamButton = UIButton()
    private let fxButton = UIButton()
    private let filterButton = UIButton()
    
    var cameraManager: CameraManager!
    private var timeEngine = TimerEngine()
    
    private var spAlert: SPAlertView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.addSubview(cameraActionStack)
        cameraActionStack.snp.makeConstraints { (make) in
            make.width.equalTo(self.frame.width)
        }
        
        // Function stack
        cameraActionStack.addArrangedSubview(functionStack, withMargin: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        functionStack.snp.makeConstraints { (make) in
            make.width.equalTo(self.frame.width * 0.7)
        }
        
        flashButton.setImage(IconHelper.shared.getIcon(iconName: .flash, currentIcon: nil).0, for: .normal)
        flashButton.addTarget(self, action: #selector(flashButtonTapped), for: .touchUpInside)
        
        timerButton.setImage(IconHelper.shared.getIcon(iconName: .timer, currentIcon: nil).0, for: .normal)
        timerButton.addTarget(self, action: #selector(timerButtonTapped), for: .touchUpInside)
        
        reverseCamButton.setImage(IconHelper.shared.getIcon(iconName: .reverse, currentIcon: nil).0, for: .normal)
        reverseCamButton.addTarget(self, action: #selector(reverseButtonTapped), for: .touchUpInside)
        
        fxButton.setImage(IconHelper.shared.getIcon(iconName: .effect, currentIcon: nil).0, for: .normal)
        fxButton.addTarget(self, action: #selector(fxButtonTapped), for: .touchUpInside)
        
        filterButton.setImage(IconHelper.shared.getIcon(iconName: .filter, currentIcon: nil).0, for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        functionStack.addArrangedSubview(flashButton)
        functionStack.addArrangedSubview(timerButton)
        functionStack.addArrangedSubview(reverseCamButton)
        functionStack.addArrangedSubview(fxButton)
        functionStack.addArrangedSubview(filterButton)
        
        // Shutter button
        let shutterButton = ShutterButtonView(frame:  CGRect(x: 0, y: 0, width: 100, height: 100))
        cameraActionStack.addArrangedSubview(shutterButton)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(shutterTapped))
        gesture.numberOfTapsRequired = 1
        shutterButton.addGestureRecognizer(gesture)
        
        for view in functionStack.arrangedSubviews {
            let view = view as! UIButton
            view.backgroundColor = .systemGray6
            view.layer.cornerRadius = 5
            view.snp.makeConstraints { (make) in
                make.width.height.equalTo(30)
            }
        }
    }
    
    @objc func shutterTapped() {
        timeEngine.presentTimerDisplay()
        TapticHelper.shared.successTaptic()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(timeEngine.currentTime)) {
            self.cameraManager.capturePictureWithCompletion({ result in
                switch result {
                case .failure:
                    print("error")
                    TapticHelper.shared.errorTaptic()
                case .success(_):
                    print("success")
                    
//                    if let image = content.asImage {
//                        PhotoLibraryEngine.shared.save(image) { (result, error) in
//                            if let e = error {
//                                fatalError("Unable saving to album \(e.localizedDescription)")
//                            }
//                        }
//                    } else {
//                        fatalError("Unable to render image.")
//                    }
                }
            })
        }
    }
    
    @objc func flashButtonTapped() {
        TapticHelper.shared.lightTaptic()
        let (image, index) = IconHelper.shared.getIcon(iconName: .flash, currentIcon: flashButton.imageView?.image?.accessibilityIdentifier!)
        
        flashButton.setImage(image, for: .normal)
        switch index {
        case 1: cameraManager.flashMode = .off
        case 2: cameraManager.flashMode = .on
        case 3: cameraManager.flashMode = .auto
        default: fatalError("Invalid index")
        }
    }
    
    @objc func timerButtonTapped() {
        TapticHelper.shared.lightTaptic()
        
        if spAlert != nil { spAlert.dismiss() }
        let time = timeEngine.ToggleTimer()
        let message = time == 0 ? "Timer: Off" : "Timer: \(time) seconds"
        spAlert = SPAlertView(title: message, message: nil, image: IconHelper.shared.getIcon(iconName: .timer, currentIcon: nil).0)
        spAlert.present()
    }
    
    @objc func reverseButtonTapped() {
        TapticHelper.shared.lightTaptic()
        let currentDevice = cameraManager.cameraDevice
        cameraManager.cameraDevice = currentDevice == CameraDevice.back ? .front : .back
    }
    
    @objc func fxButtonTapped() {
        TapticHelper.shared.lightTaptic()
    }
    
    @objc func filterButtonTapped() {
        TapticHelper.shared.lightTaptic()
    }
    
}
