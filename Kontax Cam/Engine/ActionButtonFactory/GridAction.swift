//
//  GridAction.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 24/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SPAlert

class GridAction: UIButton {

    private let grid = ["grid"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(getIcon(), for: .normal)
        self.addTarget(self, action: #selector(gridTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func gridTapped() {
        TapticHelper.shared.lightTaptic()
        
        CameraViewController.rotView.isHidden = !CameraViewController.rotView.isHidden
        
        let title = !CameraViewController.rotView.isHidden ? "Grid enabled" : "Grid disabled"
        SPAlertHelper.shared.present(title: title, message: nil, image: getIcon())
    }
    
    private func getIcon() -> UIImage {
        return IconHelper.shared.getIconImage(iconName: grid[0])
    }

}
