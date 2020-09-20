//
//  FXInfoView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 6/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI

// MARK: - FXInfoRow
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

// MARK: - FXInfoView
struct FXInfoView: View {
    var dismissAction: (() -> Void)?
    
    init(dismissAction: (() -> Void)?) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.shadowColor = .clear
        navBarAppearance.backgroundColor = .systemGroupedBackground
        
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                List {
                    Section {
                        Text("Tip: long-press any active effect(s) to customise it.".localized)
                    }
                    
                    infoRowSection
                }
                .listStyle(InsetGroupedListStyle())
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
            } else {
                List {
                    Section {
                        Text("Tip: long-press any active effect(s) to customise it.".localized)
                    }
                    
                    infoRowSection
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
}

private extension FXInfoView {
    private var infoRowSection: some View {
        Section {
            FXInfoRow(
                iconImage: Image("color.icon"),
                title: "Colour leaks".localized,
                description: "Adds a gorgeous colour overlay to your photo to make it pop and stylish.".localized
            )
            
            FXInfoRow(
                iconImage: Image(systemName: "calendar"),
                title: "Datestamp".localized,
                description: "Embed a film-styled datestamp to your photo.".localized
            )
            
            FXInfoRow(
                iconImage: Image("grain.icon"),
                title: "Grain".localized,
                description: "Ah, the good ol' grain. The essential of every 'stylish' photo.".localized
            )
            
            FXInfoRow(
                iconImage: Image("dust.icon"),
                title: "Dust".localized,
                description: "Adds a scratched and dusty effect to your photo.".localized
            )
            
            FXInfoRow(
                iconImage: Image("leaks.icon"),
                title: "Light leaks".localized,
                description: "Adds a subtle but vivid colourful light leaks - simulating a vintage film camera.".localized
            )
        }
    }
}
