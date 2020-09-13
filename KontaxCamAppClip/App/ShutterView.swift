//
//  ShutterView.swift
//  KontaxCamAppClip
//
//  Created by Kevin Laminto on 13/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class ShutterView: UIView {

    private enum TouchEvent {
        case begin, end
    }
    
    private let innerCircle = UIView()
    private var color = UIColor.label
    private let touchedColor = UIColor.label.withAlphaComponent(0.8)
    private let animationDuration: TimeInterval = 0.1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
        
        touchEvent(event: .begin)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Self
        self.backgroundColor = .clear
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = self.frame.width / 2
        
        // Inner circle
        self.addSubview(innerCircle)
        innerCircle.backgroundColor = color
        innerCircle.layer.cornerRadius = self.frame.width * 0.9 / 2
    }
    
    private func setupConstraint() {
        innerCircle.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(self.frame.width * 0.9)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.layer.borderColor = color.cgColor
    }
    
    private func renderSize(multiplier: CGFloat = 1) {
        innerCircle.transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
    }
    
    /// Tell the UI to render the layout according to the event
    /// - Parameter event: The event. Begin: When no event detected. End: When event has ended.
    private func touchEvent(event: TouchEvent) {
        switch event {
        case .begin:
            self.layer.borderColor = color.cgColor
            innerCircle.backgroundColor = color
            
        case .end:
            self.layer.borderColor = color.cgColor
            innerCircle.backgroundColor = touchedColor
        }
    }
}

extension ShutterView {
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
}
