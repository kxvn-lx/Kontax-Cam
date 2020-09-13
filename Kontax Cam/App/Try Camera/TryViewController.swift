//
//  TryViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 12/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import Backend

class TryViewController: UIViewController {
    
    var currentCollection: FilterCollection! {
        didSet {
            tryLabel.text = "You are trying \(currentCollection.name). If you like it, please purchase the collection."
        }
    }
    
    private var filtersGestureEngine: FiltersGestureEngine!
    private let cameraEngine = CameraEngine()
    private let cameraView = PreviewMetalView(frame: .zero, device: MTLCreateSystemDefaultDevice())
    private let closeButton = CloseButton()
    private let filterLabelView = FilterLabelView()
    private let rotView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "rot")
        return imageView
    }()
    
    private let tryLabel: UILabel = {
        let tryLabel = UILabel()
        tryLabel.numberOfLines = 0
        tryLabel.textAlignment = .center
        tryLabel.font = .preferredFont(forTextStyle: .caption1)
        tryLabel.textColor = .tertiaryLabel
        return tryLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup filtersGestureEngine
        filtersGestureEngine = FiltersGestureEngine(previewView: cameraView)
        filtersGestureEngine.delegate = self
        
        // Setup cameraEngine
        #if !targetEnvironment(simulator)
        cameraEngine.startCaptureSession()
        #endif
        
        setupView()
        setupConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraEngine.showFilter = true
        filtersGestureEngine.collectionCount = currentCollection.filters.count + 1
        cameraEngine.renderNewFilter(withFilterName: currentCollection.filters.first!)
        filterLabelView.titleLabel.text = currentCollection.filters.first!.rawValue.uppercased()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetCameraView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        #if !targetEnvironment(simulator)
        cameraEngine.addPreviewLayer(toView: cameraView)
        #endif
    }
    
    private func setupView() {
        // Close button
        self.view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // View
        self.view.backgroundColor = .systemBackground
        
        // Try label
        self.view.addSubview(tryLabel)
        
        // Camera view
        cameraView.backgroundColor = .systemGray6
        cameraView.isUserInteractionEnabled = true
        self.view.addSubview(cameraView)
        
        // RotView
        self.view.addSubview(rotView)
        
        // Filter label
        cameraView.addSubview(filterLabelView)
    }
    
    private func setupConstraint() {
        closeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.view.getSafeAreaInsets().top + 15)
            make.left.equalToSuperview().offset(15)
        }
        
        cameraView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width * 0.95)
            make.height.equalTo(self.view.frame.height * 0.65)
            make.top.equalTo(closeButton.snp.bottom).offset(10 + self.view.getSafeAreaInsets().top)
            make.centerX.equalToSuperview()
        }
        
        rotView.snp.makeConstraints { (make) in
            make.edges.equalTo(cameraView)
        }
        
        filterLabelView.snp.makeConstraints { (make) in
            make.height.width.equalTo(45)
            make.left.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0))
        }
        
        tryLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.top.equalTo(cameraView.snp.bottom).offset(50)
        }
    }
    
    /// Reset the camera view to improve performance
    private func resetCameraView() {
        cameraView.pixelBuffer = nil
        cameraView.flushTextureCache()
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

extension TryViewController: FiltersGestureDelegate {
    func didSwipeToChangeFilter(withNewIndex newIndex: Int) {
        TapticHelper.shared.lightTaptic()
        cameraEngine.showFilter = newIndex > 0
        if newIndex > 0 {
            cameraEngine.renderNewFilter(withFilterName: currentCollection.filters[newIndex - 1])
            filterLabelView.titleLabel.text = currentCollection.filters[newIndex - 1].rawValue.uppercased()
        } else {
            filterLabelView.titleLabel.text = "OFF"
        }
    }
}
