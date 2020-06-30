//
//  FilterMenu.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 17/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct FilterSection {
    typealias Action = ((FilterSection) -> Void)
    
    var title: String
    var items: [FilterItem]
    var action: Action?
    
    init(title: String, items: [FilterItem], action: Action?) {
        self.title = title
        self.items = items
        self.action = action
    }
}

struct FilterItem {
    typealias Action = ((FilterItem) -> Void)
    
    var title: String
    var action: Action?
    
    init(title: String, action: Action?) {
        self.title = title
        self.action = action
    }
}
