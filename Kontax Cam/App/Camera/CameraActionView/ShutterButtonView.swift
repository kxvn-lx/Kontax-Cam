//
//  ShutterButtonView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SnapKit

enum TouchEvent {
    case begin, end
}

class ShutterButtonView: UIView {

    private let animationDuration: TimeInterval = 0.05
    private let color = UIColor.systemBlue
    private let touchedColor = UIColor.systemBlue.withAlphaComponent(0.8)
    
    private var oriFrame: CGRect!
    
    private let innerCircle = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.oriFrame = frame
        self.addSubview(innerCircle)
        
        
        // View configuration
        self.isUserInteractionEnabled = true
        
        // View UI
        self.layer.borderWidth = 2
        
        self.translatesAutoresizingMaskIntoConstraints = false
        innerCircle.translatesAutoresizingMaskIntoConstraints = false
        
        touchEvent(event: .begin)
        renderSize()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Touch event listener
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.touchEvent(event: .begin)
            UIView.animate(withDuration: self.animationDuration) {
                self.touchEvent(event: .end)
                self.renderSize(multiplier: 0.98)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.touchEvent(event: .end)
            self.renderSize(multiplier: 0.98)
            UIView.animate(withDuration: self.animationDuration) {
                self.touchEvent(event: .begin)
                self.renderSize()
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.touchEvent(event: .end)
            self.renderSize(multiplier: 0.98)
            UIView.animate(withDuration: self.animationDuration) {
                self.touchEvent(event: .begin)
                self.renderSize()
            }
        }
    }
    
    private func renderSize(multiplier: CGFloat = 1) {
        self.snp.remakeConstraints { (make) in
            make.height.width.equalTo( oriFrame.width )
        }
        self.layer.cornerRadius = ( oriFrame.width * multiplier ) / 2
        
        innerCircle.snp.remakeConstraints { (make) in
            make.height.width.equalTo(oriFrame.width * 0.9 * multiplier)
            make.center.equalTo(self)
        }
        innerCircle.layer.cornerRadius = ( oriFrame.width * 0.9 * multiplier ) / 2
    }
    
    /// Tell the UI to render the layout according to the event
    /// - Parameter event: The event. Begin: When no event detected. End: When event has ended.
    private func touchEvent(event: TouchEvent) {
        switch event {
        case .begin:
            self.backgroundColor = .clear
            self.layer.borderColor = color.cgColor
            
            innerCircle.backgroundColor = color
            
        case .end:
            self.backgroundColor = .clear
            self.layer.borderColor = color.cgColor
            
            innerCircle.backgroundColor = touchedColor
        }
    }

}
