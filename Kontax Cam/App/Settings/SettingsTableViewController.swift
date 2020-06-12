//
//  SettingsTableViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 12/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    private struct CellPath {
        static let appearanceCell = IndexPath(row: 0, section: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar(tintColor: .label, title: "Settings", preferredLargeTitle: false, removeSeparator: true)
        
        setupUI()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case CellPath.appearanceCell: self.appearanceCellTapped()
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath {
        case CellPath.appearanceCell: cell.detailTextLabel?.text = getAppearanceValue()
        default: break
        }
    }
    
    private func setupUI() {
        let closeButton = CloseButton()
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        self.tableView.backgroundColor = .systemBackground
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func getAppearanceValue() -> String {
        let appearanceValue = UIUserInterfaceStyle(rawValue: UserDefaultsHelper.shared.getData(type: Int.self, forKey: .userAppearance) ?? 0)
        switch appearanceValue!.rawValue {
            case 0: return "System"
            case 1: return "Light"
            case 2: return "Dark"
            default: return "System"
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let cell = tableView.cellForRow(at: CellPath.appearanceCell)
        cell?.detailTextLabel?.text = getAppearanceValue()
    }
    
}

extension SettingsTableViewController {
    
    // MARK: - onCellTapped event Listener
    private func appearanceCellTapped() {
        let vc = AppearanceTableViewController()
        
        let navController = PanModalNavigationController(rootViewController: vc)
        navController.modalDestination = .appearance
        
        self.presentPanModal(navController)
    }
}
