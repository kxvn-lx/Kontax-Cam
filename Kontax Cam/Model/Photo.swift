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
    
    init(image: UIImage, url: URL) {
        self.image = image
        self.url = url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.url == rhs.url
    }
}
