//
//  LabMoreActionTableViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 30/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import PanModal
import Backend

protocol LabMoreActionDelegate: class {
    func didSelectImport()
}

class LabMoreActionTableViewController: UITableViewController {

    private let ReuseIdentifier = "LabMoreActionCell"
    weak var delegate: LabMoreActionDelegate?
    private var tableviewSections = [SettingsSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarTitle("", backgroundColor: .systemGroupedBackground)
        view.backgroundColor = .systemGroupedBackground
        self.addCloseButton()
        
        configureDatasource()
    }
    
    private func configureDatasource() {
        let moreSection = SettingsSection(
            title: "",
            cells: [
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Import from camera roll", andImage: UIImage(systemName: "tray.and.arrow.down")!) },
                    action: { [weak self] _ in self?.delegate?.didSelectImport() }
                )
            ]
        )
        
        tableviewSections = [moreSection]
    }
    
    /// Helper to create a cell with a title
    private func createNormalCell(withTitle title: String, andImage image: UIImage) -> LabMoreActionCell {
        let cell = LabMoreActionCell()
        cell.titleLabel.text = title.localized
        cell.actionImageView.image = image.withRenderingMode(.alwaysTemplate)
        return cell
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableviewSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewSections[section].cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableviewSections[indexPath.section].cells[indexPath.row].createdCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableviewSections[indexPath.section].cells[indexPath.row]
        
        self.dismiss(animated: true, completion: nil)
        cell.action?(cell)
    }
}

extension LabMoreActionTableViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return tableView
    }
}

// MARK: - LabMoreActionCell
class LabMoreActionCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(actionImageView)
    }
    
    private func setupConstraint() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        actionImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
    }
}
