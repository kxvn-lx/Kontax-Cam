//
//  KontaxCamWidget.swift
//  KontaxCamWidget
//
//  Created by Kevin Laminto on 19/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct PhotoEntry: TimelineEntry {
    let date = Date()
    let photo: Photo
}

/// Provides snapshot when widgetkit wants an entry
struct Provider: TimelineProvider {
    /// Provides snapshot when widgetkit just wants one entry.
    /// like in Widget library
    func getSnapshot(in context: Context, completion: @escaping (PhotoEntry) -> Void) {
        completion(PhotoEntry(photo: .static_photo))
    }
    
    /// When user has added a widget to their home screeen, this is needed to provide
    /// a full timeline
    func getTimeline(in context: Context, completion: @escaping (Timeline<PhotoEntry>) -> Void) {
        print("timeline")
        var entry = PhotoEntry(photo: .static_photo)
        if let randomphoto = DataEngine.shared.randomPhoto() {
            entry = PhotoEntry(photo: randomphoto)
        }
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

/// The main View that will be displayed by the WidgetKit
struct WidgetEntryView: View {
    let entry: Provider.Entry
    
    var body: some View {
        MasterpieceView(photo: entry.photo)
    }
}

@main
struct KontaxCamWidget: Widget {
    private let kind = "KontaxCamWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()) { (entry) in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Your masterpiece")
        .description("Your photo displayed directly from the lab.")
        
    }
}

struct KontaxCamWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MasterpieceView(photo: .static_photo)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            MasterpieceView(photo: .static_photo)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            MasterpieceView(photo: .static_photo)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
