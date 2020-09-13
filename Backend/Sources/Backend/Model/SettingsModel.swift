//
//  SettingsModel.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 16/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

public struct SettingsSection {
    public var title: String
    public var cells: [SettingsItem]
    
    public init(title: String, cells: [SettingsItem]) {
        self.title = title
        self.cells = cells
    }
}

public struct SettingsItem {
    public var createdCell: () -> UITableViewCell
    public var action: ((SettingsItem) -> Swift.Void)?
    
    public init(createdCell: @escaping () -> UITableViewCell, action: ((SettingsItem) -> Swift.Void)?) {
        self.createdCell = createdCell
        self.action = action
    }
}
