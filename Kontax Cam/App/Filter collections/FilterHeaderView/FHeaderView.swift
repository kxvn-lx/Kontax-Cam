//
//  FHeaderView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 3/10/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI

struct FHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("filterHeaderLabel")
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Image(systemName: "heart.circle")
                Text("Save 25% by purchasing the whole collections!")
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Button(action: {
                    
                }, label: {
                    Text("Purchase")
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                        .border(Color.secondaryLabel, width: 1)
                })
            }
            
            Divider()
        }
        .padding()
        .font(.caption)
        .foregroundColor(.secondaryLabel)
    }
}

struct FHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        FHeaderView()
    }
}
