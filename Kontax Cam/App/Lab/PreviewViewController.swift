//
//  PreviewViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 15/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    private let duration: Double = 0.2
    private let backgroundOpacity: CGFloat = 0.8
    private let scaleFactor: CGFloat = 1
    
    let imageView: UIImageView = {
       let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: duration) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(self.backgroundOpacity)
            self.imageView.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .clear
        self.view.addSubview(imageView)
        
        imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    private func setupConstraint() {
        imageView.snp.makeConstraints { (make) in
            make.center.height.equalToSuperview()
            make.width.equalTo(self.view.frame.width * 0.85)
        }
    }
    
    func animateOut(completion: @escaping ((Bool) -> Void)) {        
        UIView.animate(withDuration: duration, animations: {
            self.view.backgroundColor = .clear
            self.imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }) { (_) in
            completion(true)
        }
    }

}
