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
    case Pride = "Colourful"
    
    func getIconName(forIconImageView: Bool) -> String? {
        switch self {
        case .KontaxOriginal: return forIconImageView ? self.rawValue : nil
        case .LanigiroXatnok: return "lanigirO xatnoK"
        case .Pride: return "PRIDE"
        default: return self.rawValue
        }
    }
}

class AppIconsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarTitle("App icons", backgroundColor: .systemGroupedBackground)
        self.tableView.register(AppIconsTableViewCell.self, forCellReuseIdentifier: AppIconsTableViewCell.ReuseIdentifier)
        
        let closeButton = CloseButton()
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    private var initIndexPath: IndexPath?
    
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
        if UIApplication.shared.alternateIconName == IconNames.allCases[indexPath.row].getIconName(forIconImageView: false) {
            cell.accessoryType = .checkmark
            initIndexPath = indexPath
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UIApplication.shared.supportsAlternateIcons {
            UIApplication.shared.setAlternateIconName(IconNames.allCases[indexPath.row].getIconName(forIconImageView: false), completionHandler: nil)
            
            if let initIndexPath = initIndexPath {
                let cell = tableView.cellForRow(at: initIndexPath) as! AppIconsTableViewCell
                cell.accessoryType = .none
                self.initIndexPath = nil
            }
            
            let cell = tableView.cellForRow(at: indexPath) as! AppIconsTableViewCell
            cell.accessoryType = .checkmark
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AppIconsTableViewCell
        cell.accessoryType = .none
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
