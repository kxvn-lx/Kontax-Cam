//
//  CameraActionView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SnapKit
import CameraManager

class CameraActionView: UIView {
    
    private let actionButtonsScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    static var cameraManager: CameraManager!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // action buttons scrollview
        self.addSubview(actionButtonsScrollView)
        actionButtonsScrollView.snp.makeConstraints { (make) in
            make.width.equalTo(self.frame.width)
            make.height.equalTo(40)
            make.top.equalTo(self).offset(10)
        }
        
        // Adding the action buttons to the scrollView
        let actionButtons = ActionButtonFactory.shared.actionButtons
        var xCoord: CGFloat = 10
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 65
        let buttonHeight: CGFloat = 35
        let gapBetweenButtons: CGFloat = 10
        
        for button in actionButtons {
            button.backgroundColor = .systemGray6
            button.layer.cornerRadius = 5
            
            button.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            button.clipsToBounds = true
            
            xCoord += buttonWidth + gapBetweenButtons
            actionButtonsScrollView.addSubview(button)
        }
        
        actionButtonsScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(actionButtons.count + 2), height: yCoord)

        // Shutter button
        let shutterButton = ShutterButtonView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.addSubview(shutterButton)
        shutterButton.snp.makeConstraints { (make) in
            make.top.equalTo(actionButtonsScrollView.snp.bottom).offset(40)
            make.centerX.equalTo(self)
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(shutterTapped))
        gesture.numberOfTapsRequired = 1
        shutterButton.addGestureRecognizer(gesture)
    }
    
    @objc func shutterTapped() {
        TimerAction.timeEngine.presentTimerDisplay()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(TimerAction.timeEngine.currentTime)) {
            CameraActionView.self.cameraManager.capturePictureWithCompletion({ result in
                switch result {
                case .failure:
                    print("error")
                    TapticHelper.shared.errorTaptic()
                case .success(_):
                    print("success")
                    
                    //                    if let image = content.asImage {
                    //                        PhotoLibraryEngine.shared.save(image) { (result, error) in
                    //                            if let e = error {
                    //                                fatalError("Unable saving to album \(e.localizedDescription)")
                    //                            }
                    //                        }
                    //                    } else {
                    //                        fatalError("Unable to render image.")
                    //                    }
                }
            })
        }
    }
}
