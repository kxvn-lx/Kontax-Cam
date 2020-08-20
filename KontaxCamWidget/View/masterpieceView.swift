//
//  MasterpieceSmallView.swift
//  KontaxCamWidgetExtension
//
//  Created by Kevin Laminto on 19/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI
import WidgetKit

struct masterpieceView: View {
    
    var photo: Photo
    @State private var date: String = "19 Aug 2020"
    @State private var time: String = "6:45 pm"
    
    var body: some View {
        ZStack {
            Image(uiImage: photo.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .onAppear(perform: {
                    (self.date, self.time) = DateConverterHelper.shared.convertToDateTime(url: photo.url)
                })
            
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [.clear, Color(.displayP3, red: 0, green: 0, blue: 0, opacity: 0.5)]), startPoint: .top, endPoint: .bottom))
            
            VStack {
                Spacer()
                Text(date)
                    .fontWeight(.bold)
                Text(time)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .foregroundColor(.white)
            .padding()
        }
    }
}

struct MasterpieceView_Previews: PreviewProvider {
    static var previews: some View {
        masterpieceView(photo: Photo.static_photo)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        masterpieceView(photo: Photo.static_photo)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        masterpieceView(photo: Photo.static_photo)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
