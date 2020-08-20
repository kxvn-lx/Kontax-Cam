//
//  WidgetEntryView.swift
//  KontaxCamWidgetExtension
//
//  Created by Kevin Laminto on 19/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI

/// The main View that will be displayed by the WidgetKit
struct WidgetEntryView: View {
    @Environment(\.widgetFamily) private var widgetFamily
    
    let entry: MasterpieceWidgetProvider.Entry
    
    @ViewBuilder
    var body: some View {
        MasterpieceSmallView(photo: entry.photo)
//        switch widgetFamily {
//        case .systemSmall: MasterpieceSmallView(photo: entry.photo)
//        case .systemMedium: MasterpieceMediumView(photo: entry.photo)
//        default: MasterpieceLargeView(photo: entry.photo)
//        }
    }
}
