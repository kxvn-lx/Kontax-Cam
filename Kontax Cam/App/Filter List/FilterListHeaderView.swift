//
//  FilterListHeaderView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 27/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FilterListHeaderView: UIView {
    
    struct Constants {
        static let contentInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    // MARK: - Views
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .bold)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(stackView)
        addSubview(seperatorView)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    func setupConstraints() {
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(Constants.contentInsets)
        }
        
        seperatorView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    // MARK: - View Configuration
    func configure(with presentable: ModalHeaderPresentable) {
        titleLabel.text = "\(presentable.title)"
    }
    
    
}
