//
//  WhatsNewEvoker.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 29/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

/// Class to manage the what's new view.
/// Will tell us wether we should present the whats new or not.
struct WhatsNewEvoker {
    var shouldPresent = false {
        didSet {
            if !shouldPresent {
                UserDefaultsHelper.shared.setData(value: UIApplication.appVersion, key: .bundleVersion)
            }
        }
    }
    
    init() {
        checkForUpdate()
    }

    private mutating func checkForUpdate() {
        let version = UIApplication.appVersion
        let savedVersion = UserDefaultsHelper.shared.getData(type: String.self, forKey: .bundleVersion)
        
        if savedVersion == version {
            print("App is up to date with bundle: \(version ?? "no version")")
            shouldPresent = false
        } else {
            print("App is not up to date")
            shouldPresent = true
        }
    }

}
