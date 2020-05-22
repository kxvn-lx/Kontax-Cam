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
    
    private var cameraActionStack = SVHelper.shared.createSV(axis: .vertical, alignment: .center, distribution: .fillProportionally)
    
    var cameraManager: CameraManager!
    
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
            make.top.equalTo(10)
        }
        
        // Shutter button
        let shutterButton = ShutterButtonView(frame:  CGRect(x: 0, y: 0, width: 100, height: 100))
        cameraActionStack.addArrangedSubview(shutterButton)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(shutterTapped))
        gesture.numberOfTapsRequired = 1
        shutterButton.addGestureRecognizer(gesture)
    }
    
    @objc func shutterTapped(sender: UITapGestureRecognizer) {
        cameraManager.capturePictureWithCompletion({ result in
            switch result {
                case .failure:
                    print("error")
                case .success(let content):
                    print("success")
            }
        })
    }
    
}
