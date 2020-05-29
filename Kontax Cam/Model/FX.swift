//
//  FX.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 29/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct FX: Equatable {
    
    let id: Int
    let title: String
}

extension FX {
    static func < (lhs: FX, rhs: FX) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func > (lhs: FX, rhs: FX) -> Bool {
        return lhs.id > rhs.id
    }
}
