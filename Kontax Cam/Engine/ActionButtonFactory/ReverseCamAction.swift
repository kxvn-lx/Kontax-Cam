//
//  ReverseCamAction.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 23/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import CameraManager

class ReverseCamAction: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(IconHelper.shared.getIcon(iconName: .reverse, currentIcon: nil).0, for: .normal)
        self.addTarget(self, action: #selector(reverseCamTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func reverseCamTapped() {
        TapticHelper.shared.lightTaptic()

        let currentDevice = CameraActionView.cameraManager.cameraDevice
        CameraActionView.cameraManager.cameraDevice = currentDevice == CameraDevice.back ? .front : .back
    }

}
