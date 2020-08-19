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
    let entry: MasterpieceWidgetProvider.Entry
    
    var body: some View {
        MasterpieceView(photo: entry.photo)
    }
}
