//
//  InAppPurchase.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 2/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct InAppPurchase {
    
    var id: String
    var registeredPurchase: RegisteredPurchase
    var title: String
    var description: String
    var price: String
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "registeredPurchase": registeredPurchase,
            "title": title,
            "description": description,
            "price": price
        ]
    }
    
}
