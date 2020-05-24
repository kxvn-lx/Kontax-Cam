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
    var shutterButton: ShutterButtonView!
    
    static var cameraManager: CameraManager!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        shutterButton.snp.makeConstraints { (make) in
            make.top.equalTo(actionButtonsScrollView.snp.bottom).offset(40)
            make.centerX.equalTo(self)
        }
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
            button.backgroundColor = .secondarySystemBackground
            button.layer.cornerRadius = 5
            
            button.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            button.clipsToBounds = true
            
            xCoord += buttonWidth + gapBetweenButtons
            actionButtonsScrollView.addSubview(button)
        }
        
        actionButtonsScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(actionButtons.count + 1), height: yCoord)

        // Shutter button
        let shutterSize = self.frame.height * 0.13
        shutterButton = ShutterButtonView(frame: CGRect(x: 0, y: 0, width: shutterSize, height: shutterSize))
        self.addSubview(shutterButton)
    }
}
