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
    
    static let static_whatsnew = WhatsNewModel(imageName: "trash.circle.fill", title: "I am trash", description: "This is the description of me. Because I am trash.")
    
    static let current_whatsnew: [WhatsNewModel] = [
        WhatsNewModel(
            imageName: "square.and.arrow.down.on.square",
            title: "Download multiple images",
            description: "You can now download multiple images! head to the lab and start downloading all of your masterpiece!"
        ),
        WhatsNewModel(
            imageName: "sparkles",
            title: "This what's new section",
            description: "This section will be all about the exciting cool new features or fixes in the future!"
        )
    ]
}
