//
//  MasterpieceLargeView.swift
//  KontaxCamWidgetExtension
//
//  Created by Kevin Laminto on 19/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI
import WidgetKit

@available(iOS 14.0, *)
struct MasterpieceLargeView: View {
    var photo: Photo
    @State private var date: String = "19 Aug 2020"
    @State private var time: String = "6:45 pm"
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                Image(uiImage: photo.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0,
                                    maxWidth: .infinity,
                                    minHeight: 0,
                                    maxHeight: 275,
                                    alignment: .center)
                    .cornerRadius(15)
                    .clipped()
                    .onAppear(perform: {
                        (self.date, self.time) = DateConverterHelper.shared.convertToDateTime(url: photo.url)
                    })
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text(date)
                        .fontWeight(.bold)
                    Text(time)
                }
                .foregroundColor(.white)
            }
            .padding()
        }
    }
}

@available(iOS 14.0, *)
struct MasterpieceLargeView_Previews: PreviewProvider {
    static var previews: some View {
        MasterpieceLargeView(photo: .static_photo)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
