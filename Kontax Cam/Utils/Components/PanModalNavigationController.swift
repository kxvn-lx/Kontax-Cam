//
//  PanModalNavigationController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 28/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import PanModal

class PanModalNavigationController: UINavigationController {
    
    private var isShortFormEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        panModalSetNeedsLayoutUpdate()
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        panModalSetNeedsLayoutUpdate()
    }
}

extension PanModalNavigationController: PanModalPresentable {
    // MARK: - Pan Modal Presentable
    var panScrollable: UIScrollView? {
        return (topViewController as? PanModalPresentable)?.panScrollable
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(200)
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(200)
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
    
    var showDragIndicator: Bool {
        return false
    }
    
    var isHapticFeedbackEnabled: Bool {
        return false
    }
    
    var shouldRoundTopCorners: Bool {
        false
    }
    
    func willTransition(to state: PanModalPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state
            else { return }

        isShortFormEnabled = false
        panModalSetNeedsLayoutUpdate()
    }
}
