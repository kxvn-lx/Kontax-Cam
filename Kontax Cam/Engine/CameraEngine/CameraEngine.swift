//
//  CameraEngine.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 28/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import AVFoundation
import CoreMotion
import UIKit

class CameraEngine: NSObject {
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    private var setupResult: SessionSetupResult = .success
    
    private var captureSession = AVCaptureSession()
    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(
        deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera],
        mediaType: .video,
        position: .unspecified)
    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    private var currentCamera: AVCaptureDevice?
    
    private var photoOutput: AVCapturePhotoOutput?
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private var captureImageCompletion: ((UIImage?) -> Void)?
    
    private var deviceOrientation: UIDeviceOrientation = .portrait
    private var cameraIsObservingDeviceOrientation = false
    
    var shouldRespondToOrientationChanges = true {
        didSet {
            if shouldRespondToOrientationChanges {
                _startFollowingDeviceOrientation()
            } else {
                _stopFollowingDeviceOrientation()
            }
        }
    }
    
    private var coreMotionManager: CMMotionManager!
    
    override init() {
        super.init()
        checkPermission()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
    }
    
    deinit {
        _stopFollowingDeviceOrientation()
    }
    
    // MARK: - Public methods
    /// Add the camera preview layer to the given view
    /// - Parameter view: The view that will receive the camera preview layer
    func addPreviewLayer(toView view: UIView) {
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer!.frame = view.bounds
        
        startRunningCaptureSession()
    }
    
    /// Capture the image
    func captureImage(completion: @escaping (UIImage?) -> Void) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
        self.captureImageCompletion = completion
    }
    
    /// Resume the capture session
    func startCaptureSession() {
        captureSession.startRunning()
        _startFollowingDeviceOrientation()
    }
    
    /// Stop the capture session, for performance
    func stopCaptureSession() {
        captureSession.stopRunning()
        _stopFollowingDeviceOrientation()
    }
    
    // MARK: - Private methods
    private func checkPermission() {
        // Check video authorization status, video access is required
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // The user has previously granted access to the camera
            break
            
        case .notDetermined:
            /*
             The user has not yet been presented with the option to grant video access
             Suspend the SessionQueue to delay session setup until the access request has completed
             */
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
            })
            
        default:
            // The user has previously denied access
            setupResult = .notAuthorized
        }
    }
    
    private func setupCaptureSession() {
        captureSession.sessionPreset = .photo
    }
    
    private func setupDevice() {
        let devices = videoDeviceDiscoverySession.devices
        for device in devices {
            if device.position == .back {
                backCamera = device
            } else if device.position == .front {
                frontCamera = device
            }
        }
        
        currentCamera = backCamera
    }
    
    private func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    private func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = .resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = .portrait
    }
    
    private func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    private func fixOrientation(withImage image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        
        var isMirrored = false
        let orientation = image.imageOrientation
        if orientation == .rightMirrored
            || orientation == .leftMirrored
            || orientation == .upMirrored
            || orientation == .downMirrored {
            isMirrored = true
        }
        
        let newOrientation = _imageOrientation(forDeviceOrientation: deviceOrientation, isMirrored: isMirrored)
        
        if image.imageOrientation != newOrientation {
            return UIImage(cgImage: cgImage, scale: image.scale, orientation: newOrientation)
        }
        
        return image
    }
    
    private func _imageOrientation(forDeviceOrientation deviceOrientation: UIDeviceOrientation, isMirrored: Bool) -> UIImage.Orientation {
        
        switch deviceOrientation {
        case .landscapeLeft:
            return isMirrored ? .upMirrored : .up
        case .landscapeRight:
            return isMirrored ? .downMirrored : .down
        default:
            break
        }
        
        return isMirrored ? .leftMirrored : .right
    }
    
    private func _startFollowingDeviceOrientation() {
        if shouldRespondToOrientationChanges, !cameraIsObservingDeviceOrientation {
            coreMotionManager = CMMotionManager()
            coreMotionManager.deviceMotionUpdateInterval = 1 / 30.0
            if coreMotionManager.isDeviceMotionAvailable {
                coreMotionManager.startDeviceMotionUpdates(to: OperationQueue()) { motion, _ in
                    guard let motion = motion else { return }
                    let x = motion.gravity.x
                    let y = motion.gravity.y
                    // TODO: Maybe do faceup and facedown too?
                    if fabs(y) >= fabs(x) {
                        self.deviceOrientation = y >= 0 ? .portraitUpsideDown : .portrait
                    } else {
                        self.deviceOrientation = x >= 0 ? .landscapeRight : .landscapeLeft
                    }
                }
                cameraIsObservingDeviceOrientation = true
            } else {
                cameraIsObservingDeviceOrientation = false
            }
        }
    }
    
    private func _stopFollowingDeviceOrientation() {
        if cameraIsObservingDeviceOrientation {
            coreMotionManager.stopDeviceMotionUpdates()
            cameraIsObservingDeviceOrientation = false
        }
    }

}

extension CameraEngine: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        var capturedImage: UIImage?

        if let data = photo.fileDataRepresentation() {
            if let image = UIImage(data: data) {
                capturedImage = fixOrientation(withImage: image)
            }
        }
        
        captureImageCompletion!(capturedImage)
    }
}
