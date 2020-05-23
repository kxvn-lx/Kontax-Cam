//
//  ShutterButtonView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SnapKit

class ShutterButtonView: UIView {

    private let animationDuration: TimeInterval = 0.05
    private let color = UIColor.systemBlue
    private let touchedColor = UIColor.systemBlue.withAlphaComponent(0.8)
    
    private var oriFrame: CGRect!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.oriFrame = frame
        
        // View configuration
        self.isUserInteractionEnabled = true
        
        // View UI
        self.backgroundColor = color
        self.translatesAutoresizingMaskIntoConstraints = false
        
        renderSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Touch event listener
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.backgroundColor = self.color
            UIView.animate(withDuration: self.animationDuration) {
                self.backgroundColor = self.touchedColor
                self.renderSize(multiplier: 0.98)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.backgroundColor = self.touchedColor
            self.renderSize(multiplier: 0.98)
            UIView.animate(withDuration: self.animationDuration) {
                self.backgroundColor = self.color
                self.renderSize()
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.backgroundColor = self.touchedColor
            self.renderSize(multiplier: 0.98)
            UIView.animate(withDuration: self.animationDuration) {
                self.backgroundColor = self.color
                self.renderSize()
            }
        }
    }
    
    private func renderSize(multiplier: CGFloat = 1) {
        self.snp.remakeConstraints { (make) in
            make.height.width.equalTo( oriFrame.width * multiplier )
        }
        self.layer.cornerRadius = ( oriFrame.width * multiplier ) / 2
    }

}
