//
//  WhatsNewEvoker.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 29/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

struct WhatsNewEvoker {
    
    var shouldPresent = false
    
    init() {
        checkForUpdate()
    }
    
    private func getCurrentAppVersion() -> String {
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
            let version = (appVersion as! String)
            return version
        }
    
    private mutating func checkForUpdate() {
        let version = getCurrentAppVersion()
        let savedVersion = UserDefaultsHelper.shared.getData(type: String.self, forKey: .bundleVersion)
        
        if savedVersion == version {
            print("App is up to date with bundle: \(version)")
            shouldPresent = false
        } else {
            print("App is not up to date")
            shouldPresent = true
            UserDefaultsHelper.shared.setData(value: version, key: .bundleVersion)
        }
    }

}
