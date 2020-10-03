//
//  KontaxButtonStyle.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 30/9/20.
//

import SwiftUI

struct KontaxButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .foregroundColor(configuration.isPressed ? Color.systemBackground.opacity(0.25) : Color.systemBackground)
            .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width)
            .background(
                Rectangle()
                    .fill(Color.label)
            )
    }
}
