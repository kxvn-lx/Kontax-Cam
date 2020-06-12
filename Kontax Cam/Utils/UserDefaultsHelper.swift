//
//  UserDefaultsHelper.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 6/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct UserDefaultsHelper {
    
    enum UserDefaultsKeys: String, CaseIterable {
        case userAppearance
        case userFxList
    } 
    
    private let defaults = UserDefaults.standard
    
    static let shared = UserDefaultsHelper()
    private init() { }
    
    func setData<T>(value: T, key: UserDefaultsKeys) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    func getData<T>(type: T.Type, forKey key: UserDefaultsKeys) -> T? {
        return defaults.object(forKey: key.rawValue) as? T
    }
    
    func removeData(key: UserDefaultsKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
