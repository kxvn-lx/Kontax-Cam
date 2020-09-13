//
//  LoadingViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 18/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import Backend

class LoadingViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PROCESSING"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .rounded(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .bold)
        return label
    }()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.startAnimating()
        return spinner
    }()
    private var mStackView: UIStackView!
    var shouldHideTitleLabel = false {
        didSet {
            titleLabel.isHidden = shouldHideTitleLabel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
        mStackView = UIStackView(arrangedSubviews: [titleLabel, spinner])
        mStackView.axis = .vertical
        mStackView.spacing = 10
        
        self.view.addSubview(mStackView)
    }
    
    private func setupConstraint() {
        mStackView.snp.makeConstraints { (make) in
            make.center.width.equalToSuperview()
        }
    }
}
