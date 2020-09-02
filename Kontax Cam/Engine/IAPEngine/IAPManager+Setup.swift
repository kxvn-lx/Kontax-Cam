//
//  IAPManager+Setup.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 2/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

extension IAPManager {
    static let isDebugMode = false

    static var registeredPurchases: Set<RegisteredPurchase> = [
        .init(suffix: "bcollection", purchaseType: .nonConsumable),
        .init(suffix: "bwcollection", purchaseType: .nonConsumable),
        .init(suffix: "hue1collection", purchaseType: .nonConsumable)
    ]
}
