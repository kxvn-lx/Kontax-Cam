//
//  CameraActionViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SnapKit

class CameraActionViewController: UIViewController {
    
    /// An array of strings filled with the icon name of the action button
    /// To change the order, re-arrange this array and the case index on the @objc function.
    private let actionButtonsIconName: [[String]] = [
        ["", "bolt.slash", "bolt", "bolt.badge.a"],
        ["", "timer.icon", "timer3.icon", "timer5.icon"],
        ["", "arrow.2.circlepath"],
        ["", "fx"],
        ["", "filters.icon"],
        ["", "grid"]
        
    ]
    var timerEngine = TimerEngine()
    var shutterSize: CGFloat! // Passed from parent
    
    private let actionButtonsScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    private var shutterButton: ShutterButtonViewController!
    private let labButton: UIButton = {
        let btn = UIButton()
        btn.setImage(IconHelper.shared.getIconImage(iconName: "tray"), for: .normal)
        btn.tintColor = .label
        btn.layer.borderColor = UIColor.label.cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        return btn
    }()
    
    weak var cameraEngine: CameraEngine? // Passed from parent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        shutterButton.view.snp.makeConstraints { (make) in
            make.top.equalTo(actionButtonsScrollView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // action buttons scrollview
        self.view.addSubview(actionButtonsScrollView)
        actionButtonsScrollView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(45)
            make.top.equalToSuperview()
        }
        
        // Adding the action buttons to the scrollView
        let actionButtons = setupActionButtons()
        var xCoord: CGFloat = 10
        let yCoord: CGFloat = 5
        let buttonWidth: CGFloat = self.view.frame.width * 0.175
        let buttonHeight: CGFloat = 35
        let gapBetweenButtons: CGFloat = 10
        
        for button in actionButtons {
            button.tintColor = .label
            actionButtonsScrollView.addSubview(button)
            
            button.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            button.clipsToBounds = true
            xCoord += buttonWidth + gapBetweenButtons
        }
        
        actionButtonsScrollView.contentSize = CGSize(
            width: buttonWidth * CGFloat(actionButtons.count + 1),
            height: buttonHeight
        )
        
        // Shutter button
        shutterButton = ShutterButtonViewController()
        shutterButton.oriFrame = CGSize(width: shutterSize, height: shutterSize)
        self.addVC(shutterButton)
        
        // Lab button
        self.view.addSubview(labButton)
        labButton.addTarget(self, action: #selector(labButtonTapped), for: .touchUpInside)
        labButton.snp.makeConstraints { (make) in
            make.top.equalTo(actionButtonsScrollView.snp.bottom).offset(25 + shutterSize / 4)
            make.centerX.equalTo(self.view.frame.width * 0.25 - shutterSize / 4)
            make.width.equalTo(buttonWidth * 1.5)
            make.height.equalTo(buttonHeight * 1.25)
        }
    }
    
    /// Setup the actionButtons for the view
    /// - Returns: The array of button ready to be added to the view
    private func setupActionButtons() -> [UIButton] {
        var buttonTag = 0
        var buttonArray: [UIButton] = []
        for buttonIconArray in actionButtonsIconName {
            let btn = UIButton()
            btn.setImage(IconHelper.shared.getIconName(currentIcon: nil, iconImageArray: buttonIconArray).0, for: .normal)
            btn.imageView?.contentMode = .scaleAspectFit
            btn.addTarget(self, action: #selector(actionButtonsTapped(sender:)), for: .touchUpInside)
            btn.tag = buttonTag
            buttonTag += 1
            buttonArray.append(btn)
        }
        
        return buttonArray
    }
}

extension CameraActionViewController {
    @objc private func actionButtonsTapped(sender: UIButton) {
        switch sender.tag {
        // Flash
        case 0:
            let (image, index) = IconHelper.shared.getIconName(currentIcon: sender.imageView?.image?.accessibilityIdentifier, iconImageArray: actionButtonsIconName[sender.tag])
            sender.setImage(image, for: .normal)
            
            switch index {
            case 1: cameraEngine?.flashMode = .off
            case 2: cameraEngine?.flashMode = .on
            case 3: cameraEngine?.flashMode = .auto
            default: fatalError("Invalid index")
            }
            
        // Timer
        case 1:
            let (image, _) = IconHelper.shared.getIconName(currentIcon: sender.imageView?.image?.accessibilityIdentifier, iconImageArray: actionButtonsIconName[sender.tag])
            sender.setImage(image, for: .normal)
            
            timerEngine.ToggleTimer()
            
        // Reverse camera
        case 2:
            cameraEngine?.switchCamera()
            
        // FX
        case 3:
            let vc = FXCollectionViewController(collectionViewLayout: UICollectionViewLayout())
            let navController = PanModalNavigationController(rootViewController: vc)
            self.presentPanModal(navController)
            
        // Filter
        case 4:
            let parent = self.parent as! CameraViewController
            let vc = FiltersCollectionViewController(collectionViewLayout: UICollectionViewLayout())
            vc.delegate = parent
            vc.selectedCollection = parent.currentCollection
            
            let navController = UINavigationController(rootViewController: vc)
            
            self.present(navController, animated: true, completion: nil)
            
        // Grid
        case 5:
            let parent = self.parent as! CameraViewController
            parent.rotView.isHidden = !parent.rotView.isHidden
            
        default: print("No button with ID is found")
        }
    }
    
    @objc private func labButtonTapped() {
        let parent = self.parent as! CameraViewController
        cameraEngine?.stopCaptureSession()
        parent.resetCameraView()
        
        let vc = LabCollectionViewController(collectionViewLayout: UICollectionViewLayout())
        
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
}
