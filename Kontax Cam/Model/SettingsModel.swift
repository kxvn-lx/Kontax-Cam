//
//  SettingsModel.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 16/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

struct SettingsSection {
    var title: String
    var cells: [SettingsItem]
}

struct SettingsItem {
    var createdCell: () -> UITableViewCell
    var action: ((SettingsItem) -> Swift.Void)?
}
