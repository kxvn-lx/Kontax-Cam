//
//  EditorPreview.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 30/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class EditorPreview: UIView {

    private let baseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let editedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var image: UIImage! {
        didSet {
            baseImageView.image = image
            editedImageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
        
        // Add tap gesture
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(didPressView))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Get the editedImage from the imageView
    func getEditedImage() -> UIImage? {
        return editedImageView.image
    }
    
    private func setupView() {
        addSubview(baseImageView)
        addSubview(editedImageView)
    }
    
    private func setupConstraint() {
        baseImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        editedImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    @objc private func didPressView(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            editedImageView.isHidden = true
        } else if sender.state == .ended {
            editedImageView.isHidden = false
        }
    }
}
