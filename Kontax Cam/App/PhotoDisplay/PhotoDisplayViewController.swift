//
//  PhotoDisplayViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 3/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import DTPhotoViewerController
import UIKit

protocol PhotoDisplayDelegate {
    func photoDisplayDidShare(photoAt index: Int)
    func photoDisplayDidSave(photoAt index: Int)
    func photoDisplayDidDelete(photoAt index: Int)
}

class PhotoDisplayViewController: DTPhotoViewerController {
    
    // MARK: - Variables
    private let toolImages = ["square.and.arrow.up", "square.and.arrow.down", "trash"]
    var images: [UIImage] = []
    lazy private var navView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    lazy private var toolView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    lazy private var navTitleLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.font = .preferredFont(forTextStyle: .body)
        v.textAlignment = .center
        return v
    }()
    lazy private var closeButton: UIButton = {
        let v = UIButton(type: .close)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    lazy private var toolSV = SVHelper.shared.createSV(axis: .horizontal, alignment: .center, distribution: .fillEqually)
    lazy private var navSV = SVHelper.shared.createSV(axis: .horizontal, alignment: .center, distribution: .fillEqually)
    
    var photoDisplayDelegate: PhotoDisplayDelegate?
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.showsHorizontalScrollIndicator = false
        
        registerClassPhotoViewer(PhotoDisplayCollectionViewCell.self)
        self.backgroundColor = .systemBackground
        
        setupUI()
        setupConstraint()
        setupToolbar()
    }
    
    private func setupUI() {
        
        self.view.addSubview(navView)
        self.view.addSubview(toolView)
        
        // Tool View
        for i in 0 ..< toolImages.count {
            let btn = UIButton()
            btn.setImage(IconHelper.shared.getIconImage(iconName: toolImages[i]), for: .normal)
            btn.tintColor = .label
            btn.tag = i
            btn.addTarget(self, action: #selector(toolButtonTapped), for: .touchUpInside)
            
            toolSV.addArrangedSubview(btn)
        }
        
        toolView.addSubview(toolSV)
        
        // Nav View
        navView.addSubview(closeButton)
        navView.addSubview(navTitleLabel)
    }
    
    private func setupConstraint() {
        let barHeight = UINavigationController().navigationBar.frame.size.height
        
        navView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(barHeight + self.view.getSafeAreaInsets().top)
            make.width.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        navTitleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        toolView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(barHeight + self.view.getSafeAreaInsets().bottom)
        }
        
        toolSV.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(barHeight)
            make.top.equalToSuperview()
        }
        
        toolSV.arrangedSubviews.forEach({
            $0.snp.makeConstraints { (make) in
                make.height.equalToSuperview()
            }
        })
        
    }
    
    private func setupToolbar() {
        navigationController?.setToolbarHidden(false, animated: false)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        var items: [UIBarButtonItem] = []
        
        for i in 0 ..< toolImages.count {
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
            btn.setImage(IconHelper.shared.getIconImage(iconName: toolImages[i]), for: .normal)
            btn.tintColor = .label
            btn.tag = i
            btn.addTarget(self, action: #selector(toolButtonTapped), for: .touchUpInside)
            
            let toolBtn = UIBarButtonItem(customView: btn)
            items.append(toolBtn)
            if i != toolImages.count - 1 { items.append(flexible) }
        }
        
        self.toolbarItems = items
    }
    
    @objc private func toolButtonTapped(sender: UIButton) {
        switch sender.tag {
        case 0:
            photoDisplayDelegate?.photoDisplayDidShare(photoAt: self.currentPhotoIndex)
            
        case 1:
            photoDisplayDelegate?.photoDisplayDidSave(photoAt: self.currentPhotoIndex)
            
        case 2:
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                self.photoDisplayDelegate?.photoDisplayDidDelete(photoAt: self.currentPhotoIndex)
                self.reloadDTView()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
        default: break
        }
    }
    
    /// Parse the given encoded timestamp and render it into strings for readability
    /// - Parameter filename: The filename of the image (in timestamp format)
    /// - Returns: The parsed timestamp into Date, and time.
    private func parseToDateTime(filename: String) -> (String, String) {
        let filenameArr = filename.components(separatedBy: "_")
        let timestamp = String(filenameArr[1].dropLast(4))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        
        let ts = Date(timeIntervalSince1970: (timestamp as NSString).doubleValue)
        let date = formatter.string(from: ts)
        
        formatter.dateFormat = "h:mm a"
        let time = formatter.string(from: ts)
        
        return(date, time)
        
    }

    private func reloadDTView() {
        self.reloadData()
        
        let cv = self.scrollView as! UICollectionView
        let numberOfItems = cv.numberOfItems(inSection: 0)
        
        if numberOfItems == 0 {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Secondary methods
    private func hideInfoOverlayView(_ animated: Bool) {
        configureOverlayViews(hidden: true, animated: animated)
    }
    
    private func showInfoOverlayView(_ animated: Bool) {
        configureOverlayViews(hidden: false, animated: animated)
    }
    
    private func configureOverlayViews(hidden: Bool, animated: Bool) {
        if hidden != navView.isHidden {
            let duration: TimeInterval = animated ? 0.2 : 0.0
            let alpha: CGFloat = hidden ? 0.0 : 1.0
            
            setOverlayElementsHidden(isHidden: false)
            
            UIView.animate(withDuration: duration, animations: {
                self.setOverlayElementsAlpha(alpha: alpha)
            }) { (_) in
                self.setOverlayElementsHidden(isHidden: hidden)
            }
        }
    }
    
    private func setOverlayElementsHidden(isHidden: Bool) {
        toolView.isHidden = isHidden
        navView.isHidden = isHidden
    }
    
    private func setOverlayElementsAlpha(alpha: CGFloat) {
        toolView.alpha = alpha
        navView.alpha = alpha
    }
    
    override func didReceiveTapGesture() {
        reverseInfoOverlayViewDisplayStatus()
    }
    
    // MARK: - DT Delegate
    @objc override func willZoomOnPhoto(at index: Int) {
        hideInfoOverlayView(false)
    }
    
    override func didEndZoomingOnPhoto(at index: Int, atScale scale: CGFloat) {
        if scale == 1 {
            showInfoOverlayView(true)
        }
    }
    
    override func didEndPresentingAnimation() {
        showInfoOverlayView(true)
    }
    
    override func willBegin(panGestureRecognizer gestureRecognizer: UIPanGestureRecognizer) {
        hideInfoOverlayView(false)
    }
    
    override func didReceiveDoubleTapGesture() {
        hideInfoOverlayView(false)
    }
    
    // Hide & Show info layer view
    private func reverseInfoOverlayViewDisplayStatus() {
        if zoomScale == 1.0 {
            if navView.isHidden == true {
                showInfoOverlayView(true)
            } else {
                hideInfoOverlayView(true)
            }
        }
    }
}
