//
//  MasterpieceMediumView.swift
//  KontaxCamWidgetExtension
//
//  Created by Kevin Laminto on 19/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI
import WidgetKit

struct MasterpieceMediumView: View {
    
    var photo: Photo
    @State private var date: String = "19 Aug 2020"
    @State private var time: String = "6:45 pm"
    
    var body: some View {
        ZStack {
            Image(uiImage: photo.image)
                .resizable()
                .scaledToFill()
            
            VStack {
                Spacer()
                Text(date)
                Text(time)
            }
            .foregroundColor(.white)
        }

    }
}

struct MasterpieceMediumView_Previews: PreviewProvider {
    static var previews: some View {
        MasterpieceMediumView(photo: Photo.static_photo)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
