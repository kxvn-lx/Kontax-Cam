//
//  WhatsNewView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 2/10/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI

struct WhatsNewView: View {
    var dismissAction: (() -> Void)?
    
    init(dismissAction: (() -> Void)?) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.shadowColor = .clear
        navBarAppearance.backgroundColor = .systemBackground
        
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Edit with the Kontax Editor")
                        .font(.headline)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 250)
                    Text("Kontax Cam now supports importing your own photo taken outside the app and edit it with Kontax cam's filters and effects.")
                    Text("To use it, simply head to the lab, and click the plus icon in the top right corner.")
                }
                Spacer()
                
                Button(action: {
                    self.dismissAction!()
                }, label: {
                    Text("Awesome! now let me in.")
                })
                .buttonStyle(KontaxButtonStyle())
            }
            .padding()
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        self.dismissAction!()
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .renderingMode(.template)
                                            .foregroundColor(.label)
                                    })
            )
        }
    }
}

struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView(dismissAction: nil)
    }
}
