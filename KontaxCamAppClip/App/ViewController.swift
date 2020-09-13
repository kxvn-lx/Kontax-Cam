//
//  ViewController.swift
//  KontaxCamAppClip
//
//  Created by Kevin Laminto on 13/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SwiftUI
import Backend

class ViewController: UIViewController {
    
    var currentCollection: FilterCollection = .aCollection
    
    private var filtersGestureEngine: FiltersGestureEngine!
    private let cameraEngine = CameraEngine()
    private let cameraView = PreviewMetalView(frame: .zero, device: MTLCreateSystemDefaultDevice())
    private let filterLabelView = FilterLabelView()
    private let rotView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "rot")
        return imageView
    }()
    private var shutterView: ShutterView!
    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = "Swipe left or right to live preview all the available filters in the collection."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    private var cameraActionViewHeight: CGFloat {
        return (self.view.frame.height - self.view.frame.height * 0.7) - (view.safeAreaInsets.top * 0.5)
    }
    
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
        
        // Setup tap gesture for shutter view
        let gesture = UITapGestureRecognizer(target: self, action: #selector(shutterTapped))
        gesture.numberOfTapsRequired = 1
        shutterView.addGestureRecognizer(gesture)
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
        // Shutter view
        shutterView = ShutterView(frame: CGRect(origin: .zero, size: CGSize(width: cameraActionViewHeight * 0.4, height: cameraActionViewHeight * 0.4)))
        self.view.addSubview(shutterView)
        
        // View
        self.view.backgroundColor = .systemBackground
        
        // Camera view
        cameraView.backgroundColor = .systemGray6
        cameraView.isUserInteractionEnabled = true
        self.view.addSubview(cameraView)
        
        // RotView
        self.view.addSubview(rotView)
        
        // Filter label
        cameraView.addSubview(filterLabelView)
        
        // Desc label
        self.view.addSubview(descLabel)
    }
    
    private func setupConstraint() {
        cameraView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width * 0.95)
            make.height.equalTo(self.view.frame.height * 0.65)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(10)
            make.centerX.equalToSuperview()
        }
        
        rotView.snp.makeConstraints { (make) in
            make.edges.equalTo(cameraView)
        }
        
        filterLabelView.snp.makeConstraints { (make) in
            make.height.width.equalTo(45)
            make.left.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0))
        }
        
        shutterView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-30)
            make.width.height.equalTo(cameraActionViewHeight * 0.4)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.top.equalTo(cameraView.snp.bottom).offset(25)
        }
    }
    
    /// Reset the camera view to improve performance
    private func resetCameraView() {
        cameraView.pixelBuffer = nil
        cameraView.flushTextureCache()
    }
    
    @objc private func shutterTapped() {
        self.view.isUserInteractionEnabled = false
        let loadingVC = LoadingViewController()
        
        cameraEngine.captureImage { [weak self] (capturedImage) in
            guard let self = self, let image = capturedImage else { return }
            self.cameraEngine.isCapturing = true
            self.addVC(loadingVC)
            
            DispatchQueue.main.async {
                guard let editedImage = FilterEngine.shared.process(originalImage: image) else { return }
                TapticHelper.shared.successTaptic()
                loadingVC.removeVC()
                self.cameraEngine.isCapturing = false
                
                let previewView = UIHostingController(rootView: PreviewView(image: Image(uiImage: editedImage), dismissAction: { self.dismiss(animated: true, completion: nil) }))
                previewView.modalPresentationStyle = .overFullScreen
                self.present(previewView, animated: true, completion: nil)
            }
            self.view.isUserInteractionEnabled = true
        }
    }
}

extension ViewController: FiltersGestureDelegate {
    func didSwipeToChangeFilter(withNewIndex newIndex: Int) {
        TapticHelper.shared.lightTaptic()
        cameraEngine.showFilter = newIndex > 0
        if newIndex > 0 {
            cameraEngine.renderNewFilter(withFilterName: currentCollection.filters[newIndex - 1])
            filterLabelView.titleLabel.text = currentCollection.filters[newIndex - 1].rawValue.uppercased()
            LUTImageFilter.selectedLUTFilter = currentCollection.filters[newIndex - 1]
        } else {
            filterLabelView.titleLabel.text = "OFF"
            LUTImageFilter.selectedLUTFilter = nil
        }
    }
}
