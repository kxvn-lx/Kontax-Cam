//
//  MasterpieceSmallView.swift
//  KontaxCamWidgetExtension
//
//  Created by Kevin Laminto on 19/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI
import WidgetKit

@available(iOS 14.0, *)
struct MasterpieceSmallView: View {
    var photo: Photo
    @State private var date: String = "19 Aug 2020"
    @State private var time: String = "6:45 pm"
    
    var body: some View {
        ZStack {
            Image(uiImage: photo.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .onAppear(perform: {
                    (self.date, self.time) = DateConverterHelper.shared.convertToDateTime(url: photo.url)
                })
            
            Rectangle()
                .fill(Color.black)
                .opacity(0.5)
            
            VStack {
                Text(date)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text(time)
                    .font(.title3)
            }
            .foregroundColor(.white)
        }
    }
}

@available(iOS 14.0, *)
struct MasterpieceView_Previews: PreviewProvider {
    static var previews: some View {
        MasterpieceSmallView(photo: Photo.static_photo)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
