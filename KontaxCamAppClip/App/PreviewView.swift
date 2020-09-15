//
//  PreviewView.swift
//  KontaxCamAppClip
//
//  Created by Kevin Laminto on 13/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI
import StoreKit
import Backend

struct PreviewView: View {
    var image: Image
    var dismissAction: (() -> Void)?
    
    @State private var showOverlay = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertDescription = ""
    
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
                
                VStack {
                    Divider()
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Text("Kc.")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Powered by Kontax Cam")
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
                                , trailing:
                                    Button(action: {
                                        self.alertTitle = "Some info for ya!"
                                        self.alertDescription = "To save, use other effects and filters, please download the full app."
                                        self.showAlert = true
                                    }, label: {
                                        Image(systemName: "info.circle")
                                            .renderingMode(.template)
                                            .foregroundColor(.label)
                                    })
            )
            .navigationBarTitle(Text(""), displayMode: .inline)
            .appStoreOverlay(isPresented: $showOverlay) { () -> SKOverlay.Configuration in
                return SKOverlay.AppClipConfiguration(position: .bottom)
            }
            .alert(isPresented: $showAlert) { () -> Alert in
                Alert(title: Text(self.alertTitle), message: Text(self.alertDescription), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showOverlay = true
                }
            }
        }
    }
}
