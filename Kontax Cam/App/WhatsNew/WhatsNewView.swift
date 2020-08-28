//
//  WhatsNewView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 29/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI

struct WhatsNewView: View {
    var dismissAction: (() -> Void)
    
    private let iconHeight: CGFloat = 75
    private var cornerRadius: CGFloat {
        return iconHeight / 4
    }
    
    var body: some View {
        ZStack {
            Color.systemBackground
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                VStack(spacing: 50) {
                    VStack {
                        Spacer()
                            .frame(height: 75)
                        Image("appIcon-ori")
                            .resizable()
                            .frame(width: iconHeight, height: iconHeight)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                        Text("Welcome to\nKontax Cam 👋")
                            .font(.title)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                    
                    ScrollView(.vertical) {
                        VStack(spacing: 50) {
                            ForEach(WhatsNewModel.current_whatsnew) { whatsNewItem in
                                WhatsNewRow(whatsNew: whatsNewItem)
                            }
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity)

                }
                
                Spacer()
                
                Button(action: {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    dismissAction()
                }, label: {
                    Text("Awesome, now let me in!")
                })
                .buttonStyle(PrimaryButtonStyle())
                
                Spacer()
                    .frame(height: 50)
            }
        }
    }
}
