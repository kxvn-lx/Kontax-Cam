//
//  FXInfoView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 6/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI

struct FXInfoRow: View {
    var iconImage: Image
    var title: String
    var description: String
    
    private let imageFrameSize: CGFloat = 30
    
    var body: some View {
        HStack(spacing: 20) {
            iconImage
                .resizable()
                .frame(width: imageFrameSize, height: imageFrameSize)
                .scaledToFit()
                .foregroundColor(.label)
            
            VStack(alignment: .leading) {
                Text(title)
                Text(description)
                    .font(.callout)
                    .foregroundColor(.secondaryLabel)
            }
        }
        .padding(.vertical)
    }
}

struct FXInfoView: View {
    var dismissAction: (() -> Void)?
    
    init(dismissAction: (() -> Void)?) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.shadowColor = .clear
        
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Tip: you can long-press any active effect(s) in order to cutsomise it")
                }
                
                Section {
                    FXInfoRow(
                        iconImage: Image("color.icon"),
                        title: "Colour leaks",
                        description: "Colour leaks adds a gorgeous vintage colour overlay to your photo to make it pop and stylish. Experiment to find your own colour!"
                    )
                    
                    FXInfoRow(
                        iconImage: Image(systemName: "calendar"),
                        title: "Datestamp",
                        description: "Datestamp embed a vintage film-styled datestamp to your photo making it looks vintage and unique."
                    )
                    
                    FXInfoRow(
                        iconImage: Image("grain.icon"),
                        title: "Grain",
                        description: "Ah, The good ol' grain. The essential of every 'stylish' photo."
                    )
                    
                    FXInfoRow(
                        iconImage: Image("dust.icon"),
                        title: "Dust",
                        description: "Dust, like the name implies, adds a scratched and dust effect to your photo. Use this to make it look dated and vintage."
                    )
                    
                    FXInfoRow(
                        iconImage: Image("leaks.icon"),
                        title: "Light leaks",
                        description: "Light leaks adds a subtle but vivid colourful light leaks - simulating a vintage film camera."
                    )
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarItems(leading:
                                    Button(action: {
                                        self.dismissAction!()
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .renderingMode(.template)
                                            .foregroundColor(.label)
                                    })
            )
            .navigationBarTitle(Text("Effects Information"), displayMode: .inline)
        }
        
    }
}

struct FXInfoView_Previews: PreviewProvider {
    static var previews: some View {
        FXInfoView(dismissAction: nil)
    }
}
