//
//  InAppPurchase.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 2/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

public struct InAppPurchase {
    
    public var id: String
    public var registeredPurchase: RegisteredPurchase
    public var title: String
    public var description: String
    public var price: String
    
    public var dictionary: [String: Any] {
        return [
            "id": id,
            "registeredPurchase": registeredPurchase,
            "title": title,
            "description": description,
            "price": price
        ]
    }
    
}
