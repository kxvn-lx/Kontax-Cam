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

@main
struct KontaxCamWidget: Widget {
    private let kind = "KontaxCamWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: MasterpieceWidgetProvider()) { (entry) in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Your masterpiece")
        .description("Random photo taken directly from your lab.")
        
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
