//
//  EditorPreview.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 30/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class EditorPreview: UIView {

    let editedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let filterLabelView = FilterLabelView()
    
    var image: UIImage! {
        didSet {
            editedImageView.image = image
            
            setupConstraint()
        }
    }
    private var tempImage: UIImage!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        // Add tap gesture
        let longpressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didPressView))
        longpressGesture.minimumPressDuration = 0.125
        self.addGestureRecognizer(longpressGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(editedImageView)
        addSubview(filterLabelView)
    }
    
    private func setupConstraint() {
        let ratio = image.size.width / image.size.height
        
        editedImageView.snp.makeConstraints { (make) in
            if ratio >= 1 {
                make.width.equalToSuperview()
                make.height.equalTo(self.snp.width).dividedBy(ratio)
            } else {
                make.height.equalToSuperview()
                make.width.equalTo(self.snp.height).multipliedBy(ratio)
            }
            make.center.equalToSuperview()
        }
        
        filterLabelView.snp.makeConstraints { (make) in
            make.bottom.equalTo(editedImageView.snp.bottom).offset(-10)
            make.left.equalTo(editedImageView.snp.left).offset(10)
            make.height.width.equalTo(45)
        }
    }
    
    @objc private func didPressView(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            tempImage = editedImageView.image
            editedImageView.image = image
        } else if sender.state == .ended {
            editedImageView.image = tempImage
        }
    }
}
