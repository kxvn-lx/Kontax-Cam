//
//  MasterpieceWidgetProvider.swift
//  KontaxCamWidgetExtension
//
//  Created by Kevin Laminto on 19/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import WidgetKit

/// Provides snapshot when widgetkit wants an entry
struct MasterpieceWidgetProvider: TimelineProvider {
    /// Provides snapshot when widgetkit just wants one entry.
    /// like in Widget library
    func getSnapshot(in context: Context, completion: @escaping (PhotoEntry) -> Void) {
        completion(PhotoEntry(photo: .static_photo))
    }
    
    /// When user has added a widget to their home screeen, this is needed to provide
    /// a full timeline
    func getTimeline(in context: Context, completion: @escaping (Timeline<PhotoEntry>) -> Void) {
        var entry = PhotoEntry(photo: .static_photo)
        if let randomphoto = DataEngine.shared.randomPhoto() {
            entry = PhotoEntry(photo: randomphoto)
        }
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}
