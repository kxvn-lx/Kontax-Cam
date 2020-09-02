//
//  RegisteredPurchase.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 2/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct RegisteredPurchase {
    
    var suffix: String
    var purchaseType: IAPManager.PurchaseType
    
    var dictionary: [String: Any] {
        return [
            "suffix": suffix,
            "purchaseType": purchaseType
        ]
    }
    
}

extension RegisteredPurchase: DocumentSerializable {
    init?(documentData: [String: Any]) {
        let suffix = documentData["sufix"] as? String ?? ""
        let purchaseType = documentData["purchaseType"] as! IAPManager.PurchaseType
        
        self.init(suffix: suffix, purchaseType: purchaseType)
    }
}

extension RegisteredPurchase: CustomDebugStringConvertible {
    var debugDescription: String {
        return "RegisteredPurchase(dictionary: \(dictionary))"
    }
}
