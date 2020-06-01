//
//  CameraActionViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SnapKit
import CameraManager

class CameraActionViewController: UIViewController {
    
    /// An array of strings filled with the icon name of the action button
    /// To change the order, re-arrange this array and the case index on the @objc function.
    private let actionButtonsIconName: [[String]] = [
        ["", "bolt.slash", "bolt", "bolt.badge.a"],
        ["", "timer"],
        ["", "arrow.2.circlepath"],
        ["", "fx"],
        ["", "paintbrush"],
        ["", "grid"]
        
    ]
    var timerEngine = TimerEngine()
    private let shutterOffset: CGFloat = 40
    
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
        btn.addTextWithImagePrefix(image: IconHelper.shared.getIconImage(iconName: "tray"), text: "Lab")
        btn.tintColor = .label
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 35 / 2
        btn.backgroundColor = .secondarySystemBackground
        return btn
    }()
    
    var cameraManager: CameraManager! // Passed from parent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        shutterButton.view.snp.makeConstraints { (make) in
            make.top.equalTo(actionButtonsScrollView.snp.bottom).offset(shutterOffset)
            make.centerX.equalTo(self.view)
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
            make.top.equalTo(self.view).offset(10)
        }
        
        // Adding the action buttons to the scrollView
        let actionButtons = setupActionButtons()
        var xCoord: CGFloat = 10
        let yCoord: CGFloat = UIDevice().hasNotch ? -30 : 5
        let buttonWidth: CGFloat = 65
        let buttonHeight: CGFloat = 35
        let gapBetweenButtons: CGFloat = 10
        
        for button in actionButtons {
            button.backgroundColor = .secondarySystemBackground
            button.tintColor = .label
            button.layer.cornerRadius = 5
             
            actionButtonsScrollView.addSubview(button)
            
            button.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            button.clipsToBounds = true
            xCoord += buttonWidth + gapBetweenButtons
        }
        
        actionButtonsScrollView.contentSize = CGSize(
            width: buttonWidth * CGFloat(actionButtons.count + 1),
            height: UIDevice().hasNotch ? 5 : buttonHeight
        )
        
        // Shutter button
        let shutterSize = self.view.frame.height * 0.13
        shutterButton = ShutterButtonViewController()
        shutterButton.oriFrame = CGSize(width: shutterSize, height: shutterSize)
        self.add(shutterButton)
        
        // Lab button
        self.view.addSubview(labButton)
        labButton.addTarget(self, action: #selector(labButtonTapped), for: .touchUpInside)
        let calc = shutterSize / 2 - (35 * 1.25 / 2)
        labButton.snp.makeConstraints { (make) in
            make.width.equalTo(65 * 1.5)
            make.height.equalTo(35 * 1.25)
            make.top.equalTo(actionButtonsScrollView.snp.bottom).offset(40 + calc)
            make.centerX.equalTo(self.view.frame.width * 0.25 - shutterSize / 4)
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
        TapticHelper.shared.lightTaptic()
        
        switch sender.tag {
            // Flash
        case 0:
            let (image, index) = IconHelper.shared.getIconName(currentIcon: sender.imageView?.image?.accessibilityIdentifier, iconImageArray: actionButtonsIconName[sender.tag])
            sender.setImage(image, for: .normal)
            
            switch index {
            case 1: cameraManager.flashMode = .off
            case 2: cameraManager.flashMode = .on
            case 3: cameraManager.flashMode = .auto
            default: fatalError("Invalid index")
            }
            
            // Timer
        case 1:
            let time = timerEngine.ToggleTimer()
            let title = time == 0 ? "Timer: Off" : "Timer: \(time) seconds"
            SPAlertHelper.shared.present(title: title, message: nil, image: IconHelper.shared.getIconImage(iconName: (sender.imageView?.image?.accessibilityIdentifier)!))
            
            // Reverse camera
        case 2:
            let currentDevice = cameraManager.cameraDevice
            cameraManager.cameraDevice = currentDevice == CameraDevice.back ? .front : .back
            
            // FX
        case 3:
            if let parent = self.parent {
                let vc = parent.storyboard!.instantiateViewController(withIdentifier: "fxVC") as! FXCollectionViewController

                let navController = PanModalNavigationController(rootViewController: vc)
                
                self.presentPanModal(navController)
            }

            
            // Filter
        case 4:
            if let parent = self.parent {
                let vc = parent.storyboard!.instantiateViewController(withIdentifier: "filtersVC") as! FiltersCollectionViewController
                vc.delegate = shutterButton
                vc.selectedFilterName = LUTImageFilter.selectedLUTFilter

                let navController = PanModalNavigationController(rootViewController: vc)
                
                self.presentPanModal(navController)
            }

            // Grid
        case 5:
            let parent = self.parent as! CameraViewController
            
            parent.rotView.isHidden = !parent.rotView.isHidden
            let title = !parent.rotView.isHidden ? "Grid enabled" : "Grid disabled"
            SPAlertHelper.shared.present(title: title, message: nil, image: IconHelper.shared.getIconName(currentIcon: (sender.imageView?.image?.accessibilityIdentifier)!, iconImageArray: actionButtonsIconName[sender.tag]).0)

        default: print("No button with ID is found")
        }
    }
    
    @objc private func labButtonTapped() {
        if let parent = self.parent {
            TapticHelper.shared.lightTaptic()
            let vc = parent.storyboard!.instantiateViewController(withIdentifier: "labVC") as! LabCollectionViewController
            
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
}
