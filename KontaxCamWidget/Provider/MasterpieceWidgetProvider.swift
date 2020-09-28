//
//  MasterpieceWidgetProvider.swift
//  KontaxCamWidgetExtension
//
//  Created by Kevin Laminto on 19/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import WidgetKit
import Backend

/// Provides snapshot when widgetkit wants an entry
struct MasterpieceWidgetProvider: TimelineProvider {
    /// Provides snapshot when widgetkit just wants one entry.
    /// like in Widget library
    func getSnapshot(in context: Context, completion: @escaping (PhotoEntry) -> Void) {
        print("Snapshot activated")
        let entry = PhotoEntry(photo: DataEngine.shared.randomPhoto() ?? .static_photo)
        completion(entry)
    }
    
    /// When user has added a widget to their home screeen, this is needed to provide
    /// a full timeline
    func getTimeline(in context: Context, completion: @escaping (Timeline<PhotoEntry>) -> Void) {
        print("Timeline activated")
        let entry = PhotoEntry(photo: DataEngine.shared.randomPhoto() ?? .static_photo)
        let timeline = Timeline(entries: [entry], policy: .never)
         completion(timeline)
    }
    
    func placeholder(in context: Context) -> PhotoEntry {
        PhotoEntry(photo: .static_photo)
    }
}
