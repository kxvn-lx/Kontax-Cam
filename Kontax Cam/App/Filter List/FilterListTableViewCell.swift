//
//  FilterListTableViewCell.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 24/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FilterListTableViewCell: UITableViewCell {

    private let mStackView = SVHelper.shared.createSV(axis: .horizontal, alignment: .center, distribution: .fillProportionally)
    private let infoStackView = SVHelper.shared.createSV(axis: .vertical, alignment: .leading, distribution: .fill)
    
    let filterImageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        return v
    }()
    let filterTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: label.font.pointSize, weight: .bold)
        label.textColor = .label
        return label
    }()
    let filterSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        setupConstraint()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - setupUI
    private func setupUI() {
        self.backgroundColor = .clear
        
        self.addSubview(mStackView)
        
        mStackView.addArrangedSubview(filterImageView)
        mStackView.addArrangedSubview(infoStackView)
        
        infoStackView.addArrangedSubview(filterTitleLabel)
        infoStackView.addArrangedSubview(filterSubLabel)
    }
    
    private func setupConstraint() {
        let padding: CGFloat = 5
        mStackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        }
        
        filterImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.frame.width * 0.25)
        }
    }
}
