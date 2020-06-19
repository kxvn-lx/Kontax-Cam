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
    
    enum SpecialModalDestination {
        case filters
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var isShortFormEnabled = true
    var modalDestination: SpecialModalDestination!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: nil)
        panModalSetNeedsLayoutUpdate()
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: nil)
        panModalSetNeedsLayoutUpdate()
    }
}

extension PanModalNavigationController: PanModalPresentable {
    // MARK: - Pan Modal Presentable
    var panScrollable: UIScrollView? {
        return (topViewController as? PanModalPresentable)?.panScrollable
    }
    
    var longFormHeight: PanModalHeight {
        switch modalDestination {
        case .filters: return .maxHeight
        default: return .contentHeight(200)
        }
    }
    
    var shortFormHeight: PanModalHeight {
        switch modalDestination {
        case .filters: return .contentHeight(250)
        default: return .contentHeight(200)
        }
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
    
    func willTransition(to state: PanModalPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state
            else { return }

        isShortFormEnabled = false
        panModalSetNeedsLayoutUpdate()
    }
}
