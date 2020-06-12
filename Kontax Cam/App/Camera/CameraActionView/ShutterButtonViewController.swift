//
//  ShutterButtonViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SnapKit
import MobileCoreServices

enum TouchEvent {
    case begin, end
}

class ShutterButtonViewController: UIViewController {
    
    private let animationDuration: TimeInterval = 0.1
    private let color = UIColor.label
    private let touchedColor = UIColor.label.withAlphaComponent(0.8)
    
    var oriFrame: CGSize! // Passed from parent to determined the size of the shutter button
    private let innerCircle = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(innerCircle)
        self.view.isUserInteractionEnabled = true
        self.view.layer.borderWidth = 2
        self.view.translatesAutoresizingMaskIntoConstraints = false
        innerCircle.translatesAutoresizingMaskIntoConstraints = false
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(shutterTapped))
        gesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gesture)
        
        touchEvent(event: .begin)
        renderSize()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            touchEvent(event: .begin)
        }
    }
    
    // MARK: - Shutter tapped
    /// Handles the shutter button tapped
    @objc func shutterTapped() {
        let parent = self.parent as! CameraActionViewController
        
        if parent.timerEngine.currentTime != 0 { parent.timerEngine.presentTimerDisplay() }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(parent.timerEngine.currentTime)) {
            parent.cameraManager.capturePictureWithCompletion({ result in
                switch result {
                case .failure:
                    AlertHelper.shared.presentDefault(title: "Error", message: "Looks like there was an error capturing the image. Please try again or if problem persist, contact kevin.laminto@gmail.com", to: self)
                    
                case .success(let content):
                    
                    if let image = content.asImage {
                        guard let editedImage = FilterEngine.shared.process(originalImage: image) else {
                            TapticHelper.shared.errorTaptic()
                            return
                        }

                        guard let data = editedImage.jpegData(compressionQuality: 1.0) else {
                            TapticHelper.shared.errorTaptic()
                            return
                        }
                        
                        DataEngine.shared.save(imageData: data)
                    }
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
        self.view.snp.remakeConstraints { (make) in
            make.height.width.equalTo( oriFrame.width )
        }
        self.view.layer.cornerRadius = ( oriFrame.width * multiplier ) / 2
        
        innerCircle.snp.remakeConstraints { (make) in
            make.height.width.equalTo(oriFrame.width * 0.9 * multiplier)
            make.center.equalTo(self.view)
        }
        innerCircle.layer.cornerRadius = ( oriFrame.width * 0.9 * multiplier ) / 2
    }
    
    /// Tell the UI to render the layout according to the event
    /// - Parameter event: The event. Begin: When no event detected. End: When event has ended.
    private func touchEvent(event: TouchEvent) {
        switch event {
        case .begin:
            self.view.layer.borderColor = color.cgColor
            innerCircle.backgroundColor = color
            
        case .end:
            self.view.layer.borderColor = color.cgColor
            innerCircle.backgroundColor = touchedColor
        }
    }
}

extension ShutterButtonViewController: FilterListDelegate {
    func filterListDidSelectFilter(withFilterName filterName: FilterName) {
        LUTImageFilter.selectedLUTFilter = filterName
        
        let title = "\(LUTImageFilter.selectedLUTFilter.rawValue.uppercased()) activated"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            SPAlertHelper.shared.present(title: title)
        }
        
    }
}

