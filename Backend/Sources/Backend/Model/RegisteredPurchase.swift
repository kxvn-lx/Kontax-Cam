//
//  RegisteredPurchase.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 2/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

public struct RegisteredPurchase: Hashable {
    
    public var suffix: String
    public var purchaseType: IAPManager.PurchaseType
    
    public var dictionary: [String: Any] {
        return [
            "suffix": suffix,
            "purchaseType": purchaseType
        ]
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(suffix)
    }
}

extension RegisteredPurchase: DocumentSerializable {
    public init?(documentData: [String: Any]) {
        let suffix = documentData["sufix"] as? String ?? ""
        let purchaseType = documentData["purchaseType"] as! IAPManager.PurchaseType
        
        self.init(suffix: suffix, purchaseType: purchaseType)
    }
}

extension RegisteredPurchase: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "RegisteredPurchase(dictionary: \(dictionary))"
    }
}
