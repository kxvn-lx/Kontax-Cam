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
            Color.black
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            HStack {
                Image(uiImage: photo.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(15)
                    .clipped()
                    .onAppear(perform: {
                        (self.date, self.time) = DateConverterHelper.shared.convertToDateTime(url: photo.url)
                    })
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(date)
                        .fontWeight(.bold)
                    Text(time)
                        .foregroundColor(.gray)
                }
                .font(.callout)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.white)
            }
            .padding()
        }
    }
}

struct MasterpieceMediumView_Previews: PreviewProvider {
    static var previews: some View {
        MasterpieceMediumView(photo: Photo.static_photo)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
