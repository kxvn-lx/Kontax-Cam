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
    private var cameraActionView: CameraActionView!
    private let cameraManager = CameraManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraint()
        self.configureView()

        // Setup Camera Manager
        cameraManager.addPreviewLayerToView(self.cameraView)
        // By default, don't store to device
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.shouldFlipFrontCameraImage = false
        cameraManager.shouldUseLocationServices = true
        cameraManager.shouldRespondToOrientationChanges = false
        cameraManager.shouldKeepViewAtOrientationChanges = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Camera view
        cameraView.backgroundColor = UIColor.systemGray6

        
        // Camera Action View
        cameraActionView = CameraActionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - cameraView.frame.height))
        cameraActionView.cameraManager = cameraManager
        
        self.view.addSubview(cameraActionView)
        self.view.addSubview(cameraView)
    }
    
    private func setupConstraint() {
        cameraView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(self.view.frame.height * 0.7)
            make.top.equalTo(self.view)
        }
        
        cameraActionView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(self.view.frame.height - cameraView.frame.height)
            make.top.equalTo(cameraView.snp_bottomMargin)
        }
    }
}

