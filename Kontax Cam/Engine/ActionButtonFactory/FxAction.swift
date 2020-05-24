//
//  FxAction.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 23/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FxAction: UIButton {
    
    private let effect = ["fx"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(getIcon(), for: .normal)
        self.addTarget(self, action: #selector(fxTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func fxTapped() {
        TapticHelper.shared.lightTaptic()
    }
    
    private func getIcon() -> UIImage {
        return IconHelper.shared.getIconImage(iconName: effect[0])
    }

}
