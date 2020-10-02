//
//  WhatsNewHelper.swift
//  
//
//  Created by Kevin Laminto on 2/10/20.
//

import Foundation

public struct WhatsNewHelper {
    
    public private(set) var shouldShowWhatsNew = false
    public init() {
        checkForUpdate()
    }
    
    private func getCurrentVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        return (appVersion as! String)
    }
    
    private mutating func checkForUpdate() {
        let version = getCurrentVersion()
        let savedVersion = UserDefaultsHelper.shared.getData(type: String.self, forKey: .appVersion)
        
        if savedVersion != version {
            shouldShowWhatsNew.toggle()
            #warning("UNCOMMENT THIS")
//            UserDefaultsHelper.shared.setData(value: version, key: .appVersion)
        }
    }
}
