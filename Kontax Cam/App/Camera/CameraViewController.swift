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
    static let rotView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "rot")
        return v
    }()
    private var cameraActionView: CameraActionView!
    private let cameraManager = CameraManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Camera Manager
        cameraManager.addPreviewLayerToView(self.cameraView)
        // By default, don't store to device
        cameraManager.writeFilesToPhoneLibrary = true
        cameraManager.shouldFlipFrontCameraImage = true
        cameraManager.shouldUseLocationServices = true
        cameraManager.shouldKeepViewAtOrientationChanges = true
        
        // Pass the instance to CameraActionView
        CameraActionView.cameraManager = cameraManager
         
        NotificationCenter.default.addObserver(self, selector: #selector(presentFilterListVC), name: .presentFilterListVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentPhotoDisplayVC), name: .presentPhotoDisplayVC, object: nil)
        
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
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Camera view
        cameraView.backgroundColor = UIColor.systemGray6
        
        // Camera Action View
        cameraActionView = CameraActionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - cameraView.frame.height))
        
        self.view.addSubview(cameraActionView)
        self.view.addSubview(cameraView)
        
        // RotView
        self.view.addSubview(CameraViewController.rotView)
        CameraViewController.rotView.snp.makeConstraints { (make) in
            make.edges.equalTo(cameraView)
        }
        
        // Setting Button
        self.view.addSubview(settingButton)
        settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        settingButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(10)
            make.height.equalTo(35)
            make.width.equalTo(65)
            make.right.equalTo(self.view).offset(-10)
        }
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
    
    @objc private func settingButtonTapped() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
    // MARK: - NotificationObserver Method
    @objc private func presentFilterListVC() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "filterListVC") as! FilterListTableViewController
        vc.delegate = cameraActionView.shutterButton
        vc.selectedFilterName = cameraActionView.shutterButton.selectedFilterName
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc private func presentPhotoDisplayVC(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            let image = dict["image"] as! UIImage
            let selectedFilterName = dict["selectedFilterName"] as! String
            
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "photoDisplayVC") as! PhotoDisplayViewController
            vc.renderPhoto(originalPhoto: image, filterName: selectedFilterName)
            let navController = UINavigationController(rootViewController: vc)
            
            self.present(navController, animated: true, completion: nil)
        } else {
            fatalError("No information is being passed.")
        }
    }
}
