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
        
        self.configureView()
        self.configureNavigationBar(title: "Photo Display [Demo]", preferredLargeTitle: false)
        
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.view.frame.width * 0.9)
            make.center.equalTo(self.view)
        }
    }
    
    func renderPhoto(originalPhoto: UIImage, filterName: String) {
        let inputImage = originalPhoto
        let context = CIContext(options: nil)
        let filter = UIImage(named: filterName.lowercased())!
        

        let currentFilter = LUTEngine.shared.makeFilter(from: filter)
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        if let output = currentFilter.outputImage {
            if let cgimg = context.createCGImage(output, from: output.extent) {
                let processedImage = UIImage(cgImage: cgimg, scale: 1.0, orientation: inputImage.imageOrientation)
                self.imageView.image = processedImage


            }
        }
    }
    
    
}
