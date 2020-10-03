//
//  WhatsNewView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 2/10/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI
import SSSwiftUIGIFView
import SwiftUIX

private struct openingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("What's new on Kontax Cam".localized)
                    .font(.headline)
                Spacer()
            }

            Spacer()
        }
    }
}

private struct viewOne: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Edit with the Kontax Editor".localized)
                .font(.headline)
            SwiftUIGIFPlayerView(gifName: "whatsnew")
                .scaledToFill()
                .frame(height: 250)
                .clipped()
            Text("Kontax Cam now supports importing your own photo taken outside the app and edit it with Kontax cam's filters and effects.".localized)
            Text("To use it, simply head to the lab, and click the plus icon in the top right corner.".localized)
            Spacer()
        }
    }
}

// MARK: - Body view
struct WhatsNewView: View {
    @Environment(\.progressionController) var progressionController
    @State private var currentIndex = 0
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
                PaginationView(axis: .horizontal) {
                    openingView().eraseToAnyView()
                    viewOne().eraseToAnyView()
                }
                .currentPageIndex($currentIndex)
                Spacer()

                Button(action: {
                    if currentIndex == 1 {
                        self.dismissAction!()
                    } else {
                        currentIndex += 1
                    }
                }, label: {
                    Text(currentIndex == 1 ? "Start taking photos".localized : "Next".localized)
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
