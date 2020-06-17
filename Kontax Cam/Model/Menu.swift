//
//  Menu.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 17/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct MenuSection {
    typealias Action = ((MenuSection) -> ())
    
    var title: String
    var items: [MenuItem]
    var action: Action?
    
    init(title: String, items: [MenuItem], action: Action?) {
        self.title = title
        self.items = items
        self.action = action
    }
}

struct MenuItem {
    typealias Action = ((MenuItem) -> ())
    
    var title: String
    var action: Action?
    
    init(title: String, action: Action?) {
        self.title = title
        self.action = action
    }
}
