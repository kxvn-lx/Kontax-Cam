//
//  PhotoDisplayViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 24/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class PhotoDisplayViewController: UIViewController {
    
    let imageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar(title: "Photo Display [Demo]", preferredLargeTitle: false)
        
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.view.frame.width * 0.9)
            make.center.equalTo(self.view)
        }
    }
    
    func renderPhoto(originalPhoto: UIImage, filterName: FilterName) {
        
        if let editedImage = LUTEngine.shared.applyFilter(toImage: originalPhoto, withFilterName: filterName) {
            self.imageView.image = editedImage
        }
    }
    
    
}
