//
//  CameraViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 21/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import CameraManager
import SnapKit

class CameraViewController: UIViewController {
    
    // MARK: - Class variables
    private let cameraView = UIView()
    private let settingButton: UIButton = {
        let btn = UIButton()
        btn.setImage(IconHelper.shared.getIconImage(iconName: "gear"), for: .normal)
        btn.tintColor = .label
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addBlurEffect(style: .regular, cornerRadius: 5)
        
        return btn
    }()
    let rotView: UIImageView = {
        let v = UIImageView()
        v.alpha = 0.5
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "rot")
        return v
    }()
    private var cameraActionView: CameraActionViewController!
    private let cameraManager = CameraManager()
    
    private var cameraActionViewHeight: CGFloat!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Setup Camera Manager
        cameraManager.addPreviewLayerToView(self.cameraView)
        // By default, don't store to device
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.shouldFlipFrontCameraImage = true
        cameraManager.shouldKeepViewAtOrientationChanges = true
        
        setupUI()
        setupConstraint()
        
        self.view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraManager.resumeCaptureSession()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        cameraActionViewHeight = (self.view.frame.height - self.view.frame.height * 0.7) - (self.view.getSafeAreaInsets().top * 0.5)
        
        // Camera view
        cameraView.backgroundColor = UIColor.systemGray6
        cameraView.clipsToBounds = true
        
        // Camera Action View
        cameraActionView = CameraActionViewController()
        cameraActionView.shutterSize = (cameraActionViewHeight) * 0.5
        cameraActionView.cameraManager = cameraManager
        
        addVC(cameraActionView)
        self.view.addSubview(cameraView)
        
        // RotView
        self.view.addSubview(rotView)
        rotView.snp.makeConstraints { (make) in
            make.edges.equalTo(cameraView)
        }
        
        // Setting Button
        self.view.addSubview(settingButton)
        settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraint() {
        cameraView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width * 0.95)
            make.height.equalTo(self.view.frame.height * 0.65)
            make.top.equalToSuperview().offset(10 + self.view.getSafeAreaInsets().top)
            make.centerX.equalToSuperview()
        }
        
        cameraActionView.view.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(cameraActionViewHeight)
            make.bottom.equalToSuperview()
        }
        
        settingButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20 + self.view.getSafeAreaInsets().top)
            make.height.equalTo(35)
            make.width.equalTo(65)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    @objc private func settingButtonTapped() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "settingsVC") as! SettingsTableViewController
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
}
