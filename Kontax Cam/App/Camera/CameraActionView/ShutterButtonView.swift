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
    
    private let animationDuration: TimeInterval = 0.1
    private let color = UIColor.label
    private let touchedColor = UIColor.label.withAlphaComponent(0.8)
    var selectedFilterName = FilterName.KC01.rawValue
    
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
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(shutterTapped))
        gesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(gesture)
        
        touchEvent(event: .begin)
        renderSize()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            touchEvent(event: .begin)
        }
    }
    
    /// Handles the shutter button tapped
    @objc func shutterTapped() {
        if TimerAction.timeEngine.currentTime != 0 { TimerAction.timeEngine.presentTimerDisplay() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(TimerAction.timeEngine.currentTime)) {
            CameraActionView.cameraManager.capturePictureWithCompletion({ result in
                switch result {
                case .failure:
                    print("error capturing.")
                    TapticHelper.shared.errorTaptic()
                case .success(let content):
                    let contentDict: [String: Any] = [
                        "image": content.asImage! as UIImage,
                        "selectedFilterName": self.selectedFilterName as String
                    ]
                    
                    NotificationCenter.default.post(name: .presentPhotoDisplayVC, object: nil, userInfo: contentDict as [AnyHashable : Any])
                }
            })
        }
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
            self.layer.borderColor = color.cgColor
            innerCircle.backgroundColor = color
            
        case .end:
            self.layer.borderColor = color.cgColor
            innerCircle.backgroundColor = touchedColor
        }
    }
    
}

extension ShutterButtonView: FilterListDelegate {
    func didSelectFilter(filterName: String) {
        selectedFilterName = filterName
        
        let title = "\(filterName) activated"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            SPAlertHelper.shared.present(title: title, message: nil, image: IconHelper.shared.getIconImage(iconName: "paintbrush.fill"))
        }
        
    }
    
}

