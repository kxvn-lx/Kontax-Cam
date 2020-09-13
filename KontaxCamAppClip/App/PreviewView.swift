//
//  PreviewView.swift
//  KontaxCamAppClip
//
//  Created by Kevin Laminto on 13/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI

struct PreviewView: View {
    var image: Image
    var dismissAction: (() -> Void)?
    
    init(image: Image, dismissAction: (() -> Void)?) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.shadowColor = .clear
        navBarAppearance.backgroundColor = .systemBackground
        
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        self.image = image
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        NavigationView {
            VStack {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.8)
                    .padding()
                
                VStack {
                    Divider()
                    VStack(alignment: .center) {
                        Text("Kc.")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Powered by Kontax Cam")
                            .font(.caption)
                        Spacer()
                    }
                    
                    VStack {
                        Text("To save, use other filters, or apply some effects, please download the full app.")
                            .font(.caption)
                    }
                }
                .frame(maxHeight: UIScreen.main.bounds.height * 0.2)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(.tertiaryLabel)

            }
            .padding()
            .navigationBarItems(leading:
                                    Button(action: {
                                        self.dismissAction!()
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .renderingMode(.template)
                                            .foregroundColor(.label)
                                    })
            )
            .navigationBarTitle(Text(""), displayMode: .inline)
        }
    }
}
