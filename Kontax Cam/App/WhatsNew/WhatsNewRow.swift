//
//  WhatsNewRow.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 29/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI

struct WhatsNewRow: View {
    let whatsNew: WhatsNewModel
    private let imageHeight: CGFloat = 40
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: whatsNew.imageName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: imageHeight, height: imageHeight)
                .foregroundColor(.label)
            
            VStack(alignment: .leading) {
                Text(whatsNew.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.label)
                Text(whatsNew.description)
                    .foregroundColor(.secondaryLabel)
            }
            .fixedSize(horizontal: false, vertical: true)
            .font(.callout)
        }
    }
}

struct WhatsNewRow_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewRow(whatsNew: WhatsNewModel.current_whatsnew[0])
            .previewLayout(.sizeThatFits)
    }
}
