//
//  CloseButton.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 6/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class CloseButton: UIButton {
    
    private let buttonColor = UIColor.label
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        self.setImage(IconHelper.shared.getIconImage(iconName: "xmark"), for: .normal)
        tintColor = buttonColor
    }
}
