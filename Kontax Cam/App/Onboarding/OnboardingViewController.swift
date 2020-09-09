//
//  OnboardingViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 14/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private let imagesName: [String] = [
        "onboarding1",
        "onboarding2",
        "onboarding3",
        "onboarding4",
        "onboarding5",
        "onboarding6",
        "onboarding7"
    ]
    
    private let imageView: UIImageView = {
       let v = UIImageView()
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        return v
    }()
    private let titleLabel: UILabel = {
       let v = UILabel()
        v.text = "Kontax Cam"
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .label
        v.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold)
        return v
    }()
    private let bodyLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.textColor = .label
        v.text = "Instant camera hybrid app for films and digital photographers, by photographers."
        return v
    }()
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start taking photo", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        return button
    }()
    private let mSV = SVHelper.shared.createSV(axis: .vertical, alignment: .leading, distribution: .fill)
    
    private var timer = Timer()
    private var photoCount = 0
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        
        setupView()
        setupConstraint()
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }

    private func setupView() {
        self.imageView.image = UIImage(named: imagesName[0])!
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(onTransition), userInfo: nil, repeats: true)
        
        self.view.addSubview(imageView)
        self.view.addSubview(mSV)
        
        mSV.addArrangedSubview(titleLabel)
        mSV.addArrangedSubview(bodyLabel)
        mSV.addArrangedSubview(startButton)
        
        mSV.setCustomSpacing(20, after: bodyLabel)
    }
    
    private func setupConstraint() {
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalToSuperview().offset(125)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        mSV.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-(self.view.getSafeAreaInsets().bottom + 50))
            make.width.equalTo(self.view.frame.width * 0.8)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    @objc private func startButtonTapped() {
        TapticHelper.shared.successTaptic()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "cameraVC")
        let navVC = UINavigationController(rootViewController: controller)
        
        navVC.modalPresentationStyle = .fullScreen
        
        self.present(navVC, animated: true, completion: nil)
        
        UserDefaultsHelper.shared.setData(value: false, key: .userFirstLaunch)
    }
    
    @objc private func onTransition() {
        if photoCount < imagesName.count - 1 {
            photoCount += 1
        } else {
            photoCount = 0
        }

        UIView.transition(with: self.imageView, duration: 2.0, options: .transitionCrossDissolve, animations: {
            self.imageView.image = UIImage(named: self.imagesName[self.photoCount])
        }, completion: nil)
    }
}
