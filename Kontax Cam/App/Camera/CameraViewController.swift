//
//  CameraViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 21/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SnapKit

class CameraViewController: UIViewController {
    
    // MARK: - Class variables
    var currentCollection = FilterCollection.aCollection
    
    private var filtersGestureEngine: FiltersGestureEngine!
    private let cameraEngine = CameraEngine()
    private let cameraView = PreviewMetalView(frame: .zero, device: MTLCreateSystemDefaultDevice())
    
    private let settingButton: UIButton = {
        let btn = UIButton()
        btn.setImage(IconHelper.shared.getIconImage(iconName: "gear"), for: .normal)
        btn.tintColor = .label
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addBlurEffect(style: .regular, cornerRadius: 5)
        
        return btn
    }()
    private var cameraActionView: CameraActionViewController!
    private var cameraActionViewHeight: CGFloat {
        return (self.view.frame.height - self.view.frame.height * 0.7) - (self.view.getSafeAreaInsets().top * 0.5)
    }
    private var filterLabelView = FilterLabelView()
    
    let rotView: UIImageView = {
        let v = UIImageView()
        v.alpha = 0.5
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "rot")
        return v
    }()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupUI()
        setupConstraint()
        
        self.view.backgroundColor = .systemBackground
        
        filtersGestureEngine = FiltersGestureEngine(previewView: cameraView)
        filtersGestureEngine.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraEngine.startCaptureSession()
        
        // Show tutorial if first visit
        if UserDefaultsHelper.shared.getData(type: Bool.self, forKey: .userNeedTutorial) ?? true {
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                UserDefaultsHelper.shared.setData(value: false, key: .userNeedTutorial)
            }
            AlertHelper.shared.presentWithCustomAction(
                title: "Swipe gesture",
                message: "Swipe left or right to live preview all the available filters in the collection.",
                withCustomAction: [okAction],
                to: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraEngine.addPreviewLayer(toView: cameraView)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Camera view
        cameraView.backgroundColor = UIColor.systemGray6
        cameraView.isUserInteractionEnabled = true
        
        // Camera Action View
        cameraActionView = CameraActionViewController()
        cameraActionView.shutterSize = (cameraActionViewHeight) * 0.4
        cameraActionView.cameraEngine = self.cameraEngine
        
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
        
        // Filter label view
        cameraView.addSubview(filterLabelView)
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
        
        filterLabelView.snp.makeConstraints { (make) in
            make.height.equalTo(45)
            make.width.equalTo(45)
            make.left.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0))
        }
    }
    
    @objc private func settingButtonTapped() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "settingsVC") as! SettingsTableViewController
        
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .overFullScreen
        presentWithAnimation(navController)
    }
    
    /// Reset the camera view to improve performance
    func resetCameraView() {
        cameraView.pixelBuffer = nil
        cameraView.flushTextureCache()
    }
}

extension CameraViewController: FilterListDelegate {
    func filterListDidSelectCollection(_ collection: FilterCollection) {
        currentCollection = collection
        
        cameraEngine.showFilter = true
        filtersGestureEngine.collectionCount = currentCollection.filters.count + 1
        cameraEngine.renderNewFilter(withFilterName: currentCollection.filters.first!)
        filterLabelView.titleLabel.text = currentCollection.filters.first!.rawValue.uppercased()
        LUTImageFilter.selectedLUTFilter = currentCollection.filters.first!
    }
}

extension CameraViewController: FiltersGestureDelegate {
    func didSwipeToChangeFilter(withNewIndex newIndex: Int) {
        cameraEngine.showFilter = newIndex > 0
        if newIndex > 0 {
            cameraEngine.renderNewFilter(withFilterName: currentCollection.filters[newIndex - 1])
            LUTImageFilter.selectedLUTFilter = currentCollection.filters[newIndex - 1]
            
            filterLabelView.titleLabel.text = currentCollection.filters[newIndex - 1].rawValue.uppercased()
        } else {
            LUTImageFilter.selectedLUTFilter = nil
            filterLabelView.titleLabel.text = "OFF"
        }
    }
}
