//
//  CustomPhotoDisplayViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 3/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import DTPhotoViewerController
import UIKit

private var kElementHorizontalMargin: CGFloat { return 20 }
private var kElementHeight: CGFloat { return 40 }
private var kElementWidth: CGFloat { return 50 }
private var kElementBottomMargin: CGFloat { return 10 }

protocol SimplePhotoViewerControllerDelegate: DTPhotoViewerControllerDelegate {
    func simplePhotoViewerController(_ viewController: CustomPhotoDisplayViewController, savePhotoAt index: Int)
}

class CustomPhotoDisplayViewController: DTPhotoViewerController {
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .close)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        cancelButton.contentHorizontalAlignment = .left
        cancelButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return cancelButton
    }()
    
    lazy var moreButton: UIButton = {
        let moreButton = UIButton(type: .contactAdd)
        moreButton.contentHorizontalAlignment = .right
        moreButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kElementHorizontalMargin)
        moreButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        moreButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        return moreButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerClassPhotoViewer(CustomPhotoCollectionViewCell.self)
        view.addSubview(cancelButton)
        view.addSubview(moreButton)
        
        configureOverlayViews(hidden: true, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let y = bottomButtonsVerticalPosition()
        
        let insets: UIEdgeInsets
        
        if #available(iOS 11.0, *) {
            insets = view.safeAreaInsets
        } else {
            insets = UIEdgeInsets.zero
        }
        
        // Layout subviews
        let buttonHeight: CGFloat = kElementHeight
        let buttonWidth: CGFloat = kElementWidth
        
        cancelButton.frame = CGRect(origin: CGPoint(x: 20 + insets.left, y: insets.top), size: CGSize(width: buttonWidth, height: buttonHeight))
        moreButton.frame = CGRect(origin: CGPoint(x: view.bounds.width - buttonWidth - insets.right, y: y - insets.bottom), size: CGSize(width: buttonWidth, height: kElementHeight))
    }
    
    @objc private func moreButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        let saveButton = UIAlertAction(title: "Save", style: UIAlertAction.Style.default) { _ in
            // Save photo to Camera roll
            if let delegate = self.delegate as? SimplePhotoViewerControllerDelegate {
                delegate.simplePhotoViewerController(self, savePhotoAt: self.currentPhotoIndex)
            }
        }
        alertController.addAction(saveButton)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        hideInfoOverlayView(false)
        dismiss(animated: true, completion: nil)
    }
    
    func hideInfoOverlayView(_ animated: Bool) {
        configureOverlayViews(hidden: true, animated: animated)
    }
    
    func showInfoOverlayView(_ animated: Bool) {
        configureOverlayViews(hidden: false, animated: animated)
    }
    
    func configureOverlayViews(hidden: Bool, animated: Bool) {
        if hidden != cancelButton.isHidden {
            let duration: TimeInterval = animated ? 0.2 : 0.0
            let alpha: CGFloat = hidden ? 0.0 : 1.0
            
            // Always unhide view before animation
            setOverlayElementsHidden(isHidden: false)
            
            UIView.animate(withDuration: duration, animations: {
                self.setOverlayElementsAlpha(alpha: alpha)
            }, completion: { _ in
                self.setOverlayElementsHidden(isHidden: hidden)
            }
            )
        }
    }
    
    func setOverlayElementsHidden(isHidden: Bool) {
        cancelButton.isHidden = isHidden
        moreButton.isHidden = isHidden
    }
    
    func setOverlayElementsAlpha(alpha: CGFloat) {
        moreButton.alpha = alpha
        cancelButton.alpha = alpha
    }
    
    override func didReceiveTapGesture() {
        reverseInfoOverlayViewDisplayStatus()
    }
    
    private func bottomButtonsVerticalPosition() -> CGFloat {
        return view.bounds.height - kElementHeight - kElementBottomMargin
    }
    
    @objc
    override func willZoomOnPhoto(at index: Int) {
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
    func reverseInfoOverlayViewDisplayStatus() {
        if zoomScale == 1.0 {
            if cancelButton.isHidden == true {
                showInfoOverlayView(true)
            } else {
                hideInfoOverlayView(true)
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
