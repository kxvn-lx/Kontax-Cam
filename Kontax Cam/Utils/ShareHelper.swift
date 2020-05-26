//
//  ShareHelper.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 26/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

struct ShareHelper {
    
    private let shareText = "Simple and beautiful instant camera app #KontaxCam"
    
    static let shared = ShareHelper()
    private init() { }
    
    /// Present a default share sheet
    /// - Parameter sender: The view that will be presented the sheet is.
    func presentShare(withImage image: UIImage, toView sender: UIViewController) {

        let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
        sender.present(vc, animated: true)
    }
    
    /// Present a share context sheet
    /// - Parameters:
    ///   - image: The image that will be saved
    ///   - vc: The view controller that will present the sheet
    /// - Returns: The UI Menu ready to be presented
    func presentContextShare(image: UIImage, toVC vc: UIViewController) -> UIMenu {
        
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            let items = [self.shareText, image] as [Any]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            vc.present(ac, animated: true)
        }
        
        return UIMenu(title: "", children: [share])
        
    }
    
}
