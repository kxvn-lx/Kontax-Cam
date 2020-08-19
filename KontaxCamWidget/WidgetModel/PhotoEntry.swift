//
//  PhotoEntry.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 19/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import WidgetKit

struct PhotoEntry: TimelineEntry {
    let date = Date()
    let photo: Photo
}
