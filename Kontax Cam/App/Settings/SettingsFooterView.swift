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
        VStack(alignment: .center) {
            Text("Kc.")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Designed and developed by Kevin Laminto")
                .font(.caption)
            Spacer()
        }
        .padding()
        .multilineTextAlignment(.center)
        .foregroundColor(.tertiaryLabel)
    }
}

struct SettingsFooterView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsFooterView()
    }
}
