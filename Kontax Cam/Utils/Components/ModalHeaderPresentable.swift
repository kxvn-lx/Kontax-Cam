//
//  ModalHeaderPresentable.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 27/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

protocol ModalHeaderProtocol: class {
    func didTapInfo()
}

class ModalHeaderPresentable: UICollectionReusableView {
    
    let titleLabel = UILabel()
    let infoButton: UIButton = {
        let btn = UIButton(type: .detailDisclosure)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = UIColor.label.withAlphaComponent(0.5)
        return btn
    }()
    
    weak var delegate: ModalHeaderProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        addSubview(stackView)
        
        let titleSV = SVHelper.shared.createSV(axis: .horizontal, alignment: .center, distribution: .equalCentering)
        titleSV.addArrangedSubview(titleLabel)
        titleSV.addArrangedSubview(infoButton)
        
        stackView.addArrangedSubview(titleSV, withMargin: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: -15))
        
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        infoButton.addTarget(delegate, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        style()
    }
    
    private func style() {
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize, weight: .medium)
    }
    
    @objc private func infoButtonTapped() {
        self.delegate?.didTapInfo()
    }
}
