//
//  StoreKitReviewHelper.swift
//  
//
//  Created by Kevin Laminto on 20/9/20.
//

import Foundation
import StoreKit

public struct StoreKitReviewHelper {
    private let timesOpenedMark = 10
    
    public static let shared = StoreKitReviewHelper()
    private init() { }
    
    /// Start the Helper. Will increment the count of number of times the app is opened.
    public func start() {
        let savedvalue = UserDefaultsHelper.shared.getData(type: Int.self, forKey: .timesOpened) ?? 0
        UserDefaultsHelper.shared.setData(value: savedvalue == 0 ? 1 : savedvalue + 1, key: .timesOpened)
    }
    
    /// When executed, this method will check if the system should present a review
    public func shouldShowReview() {
        let appOpenedCountValue  = UserDefaultsHelper.shared.getData(type: Int.self, forKey: .timesOpened) ?? 0
        if appOpenedCountValue % timesOpenedMark == 0 {
            SKStoreReviewController.requestReview()
            print("App has been opened: \(appOpenedCountValue) time(s). Show review!")
        } else {
            print("App has been opened: \(appOpenedCountValue) time(s)")
        }
    }
}
