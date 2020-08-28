//
//  PrimaryButtonStyle.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 29/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .foregroundColor(.white)
            .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width * 0.8)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(configuration.isPressed ? Color(.displayP3, red: 15/255, green: 15/255, blue: 15/255, opacity: 1) : Color.black)
            )
    }
}
