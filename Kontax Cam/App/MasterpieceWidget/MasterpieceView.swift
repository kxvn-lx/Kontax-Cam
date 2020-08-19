//
//  MasterpieceView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 19/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI
import WidgetKit

@available(iOS 14.0, *)
struct MasterpieceView: View {
    var photo: Photo
    @State private var date: String = "19 Aug 2020"
    @State private var time: String = "6:45 pm"
    
    @Environment(\.widgetFamily) private var widgetFamily
    
    var body: some View {
        ZStack {
            Image(uiImage: photo.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .onAppear(perform: {
                    convertToDate(url: photo.url)
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
    
    private func convertToDate(url: URL) {
        let urlString = url.path
        let timestamp = urlString.components(separatedBy: "_").last!.components(separatedBy: ".").first!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        
        let ts = Date(timeIntervalSince1970: (timestamp as NSString).doubleValue)
        self.date = formatter.string(from: ts)
        
        formatter.dateFormat = "h:mm a"
        self.time = formatter.string(from: ts)
        
        
    }
}

@available(iOS 14.0, *)
struct MasterpieceView_Previews: PreviewProvider {
    static var previews: some View {
        MasterpieceView(photo: Photo.static_photo)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        MasterpieceView(photo: Photo.static_photo)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        MasterpieceView(photo: Photo.static_photo)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
