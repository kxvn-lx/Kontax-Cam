//
//  SettingsFooterView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 7/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI

struct SettingsFooterView: View {
    var body: some View {
        VStack {
            Text("Kontax Cam")
                .font(.caption)
                .fontWeight(.medium)
            
            Text("Designed and developed by Kevin Laminto.")
                .font(.caption)
        }
        .foregroundColor(.tertiaryLabel)
    }
}

struct SettingsFooterView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsFooterView()
    }
}
