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

class ShutterButtonViewController: UIViewController {
    
    private enum TouchEvent {
        case begin, end
    }
    
    private let animationDuration: TimeInterval = 0.1
    private var color = UIColor.label
    private let touchedColor = UIColor.label.withAlphaComponent(0.8)
    
    var oriFrame: CGSize! // Passed from parent to determined the size of the shutter button
    private let innerCircle = UIView()
    
    // MARK: - View lifecycle
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
        
        setupConstraint()
        
        touchEvent(event: .begin)
        renderSize()
    }
    
    private func setupConstraint() {
        self.view.layer.cornerRadius = oriFrame.width / 2
        innerCircle.layer.cornerRadius = oriFrame.width * 0.9 / 2
        
        self.view.snp.makeConstraints { (make) in
            make.height.width.equalTo(oriFrame.width)
        }
        
        innerCircle.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(oriFrame.width * 0.9)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.view.layer.borderColor = color.resolvedColor(with: self.traitCollection).cgColor
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
    
    private func renderSize(multiplier: CGFloat = 1) {
        innerCircle.transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
    }
    
    /// Tell the UI to render the layout according to the event
    /// - Parameter event: The event. Begin: When no event detected. End: When event has ended.
    private func touchEvent(event: TouchEvent) {
        switch event {
        case .begin:
            self.view.layer.borderColor = color.resolvedColor(with: self.traitCollection).cgColor
            innerCircle.backgroundColor = color
            
        case .end:
            self.view.layer.borderColor = color.resolvedColor(with: self.traitCollection).cgColor
            innerCircle.backgroundColor = touchedColor
        }
    }
}

extension ShutterButtonViewController: FilterListDelegate {
    func filterListDidSelectFilter() {
        let title = "\(LUTImageFilter.selectedLUTFilter.rawValue.uppercased()) activated"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            SPAlertHelper.shared.present(title: title)
        }
    }
}

extension ShutterButtonViewController {
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
