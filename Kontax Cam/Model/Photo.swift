//
//  Photo.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 15/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class Photo: Hashable {
    
    var image: UIImage!
    let url: URL!
    let id = UUID()
    
    init(image: UIImage, url: URL) {
        self.image = image
        self.url = url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let static_photo = Photo(image: UIImage(named: "A.ex4")!, url: URL(fileURLWithPath: "static_photo_url"))
}
