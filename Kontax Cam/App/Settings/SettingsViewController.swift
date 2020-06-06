//
//  SettingsViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 24/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit
import QuickTableViewController
import PanModal

class SettingsViewController: QuickTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar(tintColor: .label, title: "Settings", preferredLargeTitle: false, removeSeparator: true)
        
        setupUI()
        
        // QuickTableViewController datasource
        tableContents = [
            Section(title: nil, rows: [
                NavigationRow(text: "Appearance", detailText: .value1(""), icon: nil, action: { _ in self.appearanceCellTapped() }),
            ]),
        ]
    }
    
    private func setupUI() {
        let closeButton = CloseButton()
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        self.tableView.backgroundColor = .systemBackground
    }
    
    private func appearanceCellTapped() {
        let vc = AppearanceTableViewController()
        
        let navController = PanModalNavigationController(rootViewController: vc)
        navController.modalDestination = .appearance
        
        self.presentPanModal(navController)
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
