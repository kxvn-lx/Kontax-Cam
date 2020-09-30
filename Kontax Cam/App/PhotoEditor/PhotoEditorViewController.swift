//
//  PhotoEditorViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 30/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class PhotoEditorViewController: UIViewController {
    var image: UIImage! {
        didSet {
            imageView.image = image
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private var mStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarTitle("")
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setupActionButtons()
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        view.addSubview(imageView)
        view.addSubview(mStackView)
    }
    
    private func setupConstraint() {
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width * 0.95)
            make.height.equalTo(self.view.frame.height * 0.65)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(10)
            make.centerX.equalToSuperview()
        }
        
        mStackView.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupActionButtons() {
        let iconNames = ["fx", "filters.icon"]
        var buttonTag = 0
        
        for name in iconNames {
            let button = UIButton(type: .system)
            button.setImage(IconHelper.shared.getIconImage(iconName: name), for: .normal)
            button.tintColor = .label
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
            button.tag = buttonTag
            
            mStackView.addArrangedSubview(button)
            buttonTag += 1
        }
    }

    @objc private func actionButtonTapped(_ sender: UIButton) {
        
    }
}
