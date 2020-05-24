//
//  GridAction.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 24/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class GridAction: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(IconHelper.shared.getIcon(iconName: .grid, currentIcon: nil).0, for: .normal)
        self.addTarget(self, action: #selector(gridTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func gridTapped() {
        TapticHelper.shared.lightTaptic()
        
        CameraViewController.rotView.isHidden = !CameraViewController.rotView.isHidden
    }

}
