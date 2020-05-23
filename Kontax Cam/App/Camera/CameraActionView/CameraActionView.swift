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

class CameraActionView: UIView {
    
    private var cameraActionStack = SVHelper.shared.createSV(axis: .vertical, spacing: 40, alignment: .center, distribution: .fillProportionally)
    private var functionStack = SVHelper.shared.createSV(axis: .horizontal, alignment: .center, distribution: .equalCentering)
    
    static var cameraManager: CameraManager!
    
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
        
        // Adding the action buttons to the view
        let actionButtons = ActionButtonFactory.shared.actionButtons
        for button in actionButtons {
            button.backgroundColor = .systemGray6
            button.layer.cornerRadius = 5
            
            button.snp.makeConstraints { (make) in
                make.width.height.equalTo(30)
            }
            
            functionStack.addArrangedSubview(button)
        }
        
        // Shutter button
        let shutterButton = ShutterButtonView(frame:  CGRect(x: 0, y: 0, width: 100, height: 100))
        cameraActionStack.addArrangedSubview(shutterButton)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(shutterTapped))
        gesture.numberOfTapsRequired = 1
        shutterButton.addGestureRecognizer(gesture)
    }
    
    @objc func shutterTapped() {
        TimerAction.timeEngine.presentTimerDisplay()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(TimerAction.timeEngine.currentTime)) {
            CameraActionView.self.cameraManager.capturePictureWithCompletion({ result in
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
}
