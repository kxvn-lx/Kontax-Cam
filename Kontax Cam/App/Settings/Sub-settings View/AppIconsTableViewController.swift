//
//  AppIconsTableViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 10/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

fileprivate enum IconNames: String, CaseIterable {
    case KontaxOriginal = "Kontax Original"
    case AFineDay = "A fine day"
    case Bloodlust
    case EternalSleep = "Eternal sleep"
    case LanigiroXatnok = "Lanigiro Xatnok"
    case SummerVibes = "Summer vibes"
    case Sunshine
    
    func getIconName(forIconImageView: Bool) -> String? {
        switch self {
        case .KontaxOriginal: return forIconImageView ? self.rawValue : nil
        case .LanigiroXatnok: return "lanigirO xatnoK"
        default: return self.rawValue
        }
    }
}

class AppIconsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar(tintColor: .label, title: "App icons", preferredLargeTitle: false, removeSeparator: true)
        self.tableView.register(AppIconsTableViewCell.self, forCellReuseIdentifier: AppIconsTableViewCell.ReuseIdentifier)
        
        let closeButton = CloseButton()
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IconNames.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppIconsTableViewCell.ReuseIdentifier, for: indexPath) as! AppIconsTableViewCell
        
        cell.iconName = IconNames.allCases[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UIApplication.shared.supportsAlternateIcons {
            UIApplication.shared.setAlternateIconName(IconNames.allCases[indexPath.row].getIconName(forIconImageView: false)) { (error) in
                if let error = error {
                    AlertHelper.shared.presentOKAction(withTitle: error.localizedDescription, to: self)
                }
            }
        }
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

class AppIconsTableViewCell: UITableViewCell {
    
    static let ReuseIdentifier = "AppIconsCell"
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 50 / 4
        imageView.clipsToBounds = true
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    private var mStackView: UIStackView!
    fileprivate var iconName: IconNames! {
        didSet {
            iconImageView.image = UIImage(named: iconName.getIconName(forIconImageView: true)!)
            titleLabel.text = iconName.rawValue
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        accessoryType = selected ? .checkmark : .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        mStackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        mStackView.spacing = 20
        mStackView.isLayoutMarginsRelativeArrangement = true
        mStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        addSubview(mStackView)
    }
    
    private func setupConstraint() {
        mStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
        }
    }
}
