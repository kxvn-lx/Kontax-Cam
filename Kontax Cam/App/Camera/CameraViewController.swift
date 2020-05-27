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
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Class variables
    private let cameraView = UIView()
    private let settingButton: UIButton = {
        let btn = UIButton()
        btn.setImage(IconHelper.shared.getIconImage(iconName: "gear"), for: .normal)
        btn.tintColor = .label
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.addBlurEffect(style: .regular, cornerRadius: 5)
        
        return btn
    }()
    let rotView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "rot")
        return v
    }()
    private var cameraActionView: CameraActionViewController!
    private let cameraManager = CameraManager()
    
    // MARK: - View configuration
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Camera view
        cameraView.backgroundColor = UIColor.systemGray6
        
        // Camera Action View
        cameraActionView = CameraActionViewController()
        cameraActionView.cameraManager = cameraManager
        
        add(cameraActionView)
        self.view.addSubview(cameraView)
        
        // RotView
        self.view.addSubview(rotView)
        rotView.snp.makeConstraints { (make) in
            make.edges.equalTo(cameraView)
        }
        
        // Setting Button
        self.view.addSubview(settingButton)
        settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        settingButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.height.equalTo(35)
            make.width.equalTo(65)
            make.right.equalTo(self.view).offset(-20)
        }
    }
    
    private func setupConstraint() {
        cameraView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(self.view.frame.height * 0.7)
            make.top.equalTo(self.view)
        }
        
        cameraActionView.view.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(self.view.frame.height - cameraView.frame.height)
            make.top.equalTo(cameraView.snp_bottomMargin)
        }
    }
    
    @objc private func settingButtonTapped() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
}
