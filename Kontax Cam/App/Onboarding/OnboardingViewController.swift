//
//  OnboardingViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 14/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import Backend

class OnboardingViewController: UIViewController {
    private let imageView: UIImageView = {
       let v = UIImageView()
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        return v
    }()
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Kc."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize * 1.5, weight: .bold)
        return label
    }()
    private let bodyLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        v.textColor = .label
        v.textAlignment = .center
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
    private let mSV = SVHelper.shared.createSV(axis: .vertical, alignment: .center, distribution: .fill)
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        
        setupView()
        setupConstraint()
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }

    private func setupView() {
        self.imageView.image = UIImage(named: "onboarding")!
        self.view.addSubview(logoLabel)
        
        self.view.addSubview(imageView)
        self.view.addSubview(mSV)
        
        mSV.addArrangedSubview(bodyLabel)
        mSV.addArrangedSubview(startButton)
        
        mSV.setCustomSpacing(20, after: bodyLabel)
    }

    private func setupConstraint() {
        logoLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-75)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalTo(mSV.snp.top).offset(-50)
            make.height.equalTo(self.view.snp.width).multipliedBy(0.9)
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
}
