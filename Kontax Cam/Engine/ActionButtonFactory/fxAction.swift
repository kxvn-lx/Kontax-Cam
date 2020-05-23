//
//  fxAction.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 23/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class fxAction: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(IconHelper.shared.getIcon(iconName: .effect, currentIcon: nil).0, for: .normal)
        self.addTarget(self, action: #selector(fxTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func fxTapped() {
        TapticHelper.shared.lightTaptic()

    }

}
