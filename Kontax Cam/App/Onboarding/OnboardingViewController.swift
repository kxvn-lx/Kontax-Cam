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
        v.contentMode = .scaleAspectFill
        return v
    }()
    private let titleLabel: UILabel = {
       let v = UILabel()
        v.text = "Kontax Cam"
        v.textColor = .white
        v.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold)
        return v
    }()
    private let bodyLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.textColor = .white
        v.text = "Instant camera for film and digital creators, by creators."
        return v
    }()
    private let startButton: UIButton = {
       let v = UIButton()
        v.setImage(IconHelper.shared.getIconImage(iconName: "arrow.right"), for: .normal)
        v.imageView?.tintColor = .white
        v.backgroundColor = .black
        return v
    }()
    private let mSV = SVHelper.shared.createSV(axis: .vertical, alignment: .leading, distribution: .fill)
    
    private var timer = Timer()
    private var photoCount = 0
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

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

        let sv = SVHelper.shared.createSV(axis: .horizontal, alignment: .center, distribution: .fillProportionally)
        sv.addArrangedSubview(startButton)
        
        mSV.addArrangedSubview(sv)
        
        mSV.setCustomSpacing(10, after: titleLabel)
        mSV.setCustomSpacing(20, after: bodyLabel)
        
        sv.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
        }

    }
    
    private func setupConstraint() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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
