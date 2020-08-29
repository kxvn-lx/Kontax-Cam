//
//  WhatsNewModel.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 29/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct WhatsNewModel: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    
    static let current_whatsnew: [WhatsNewModel] = [
        WhatsNewModel(
            imageName: "sparkles",
            title: "Utlise more lens",
            description: "Kontax Cam can now provides more lens feature according to your device. (0.5x or 2x). triple camera iPhones might experience bug. Will try to fix in the next build."
        ),
        WhatsNewModel(
            imageName: "square.and.arrow.down.on.square",
            title: "Download multiple images",
            description: "You can now download multiple images! head to the lab and start downloading all of your masterpiece!"
        ),
        WhatsNewModel(
            imageName: "info",
            title: "This what's new section",
            description: "This section will be all about the exciting cool new features or fixes in the future!"
        )
    ]
}