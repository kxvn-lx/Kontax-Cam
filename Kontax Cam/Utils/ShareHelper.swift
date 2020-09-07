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

        let vc = UIActivityViewController(
            activityItems: [image],
            applicationActivities: []
        )
        sender.present(vc, animated: true)
    }
    
}
