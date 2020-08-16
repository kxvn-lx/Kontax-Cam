//
//  SettingsViewModel.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 16/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

protocol SettingsViewModelDelegate: class {
    func appearanceTapped()
    func apppIconsTapped()
    func twitterTapped()
    func websiteTapped()
    func emailTapped()
    func privacyTapped()
    func deleteAllTapped()
}

class SettingsViewModel: NSObject {
    
    static let ReuseIdentifier = "SettingsCell"
    private weak var delegate: SettingsViewModelDelegate?
    private var tableviewSections = [SettingsSection]()
    
    init(delegate: SettingsViewModelDelegate) {
        super.init()
        self.delegate = delegate
        configureDatasource()
    }
    
    private func configureDatasource() {
        let generalSection = SettingsSection(
            title: "General",
            cells: [
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Appearance") },
                    action: { [weak self] _ in self?.delegate?.appearanceTapped() }),
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "App icons") },
                    action: { [weak self] _ in self?.delegate?.apppIconsTapped() }),
            ])
        
        let informationSection = SettingsSection(
            title: "Information",
            cells: [
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Twitter") },
                    action: { [weak self] _ in self?.delegate?.twitterTapped() }),
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Website") },
                    action: { [weak self] _ in self?.delegate?.websiteTapped() }),
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Email") },
                    action: { [weak self] _ in self?.delegate?.emailTapped() }),
            ])
        
        let otherStuffSection = SettingsSection(
            title: "Other stuffs",
            cells: [
                SettingsItem(
                    createdCell: { self.createNormalCell(withTitle: "Privacy policy") },
                    action: { [weak self] _ in self?.delegate?.privacyTapped() }),
                SettingsItem(
                    createdCell: {
                        let cell = UITableViewCell(style: .value1, reuseIdentifier: Self.ReuseIdentifier)
                        cell.textLabel?.text = "Delete lab images"
                        cell.textLabel?.textColor = .systemRed
                        cell.accessoryType = .disclosureIndicator
                        return cell
                    },
                    action: { [weak self] _ in self?.delegate?.deleteAllTapped() }),
            ])
        
        self.tableviewSections = [generalSection, informationSection, otherStuffSection]
    }
    
    /// Helper to create a cell with a title
    private func createNormalCell(withTitle title: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: Self.ReuseIdentifier)
        cell.textLabel?.text = title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension SettingsViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewSections[section].cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableviewSections[indexPath.section].cells[indexPath.row].createdCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableviewSections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableviewSections[indexPath.section].cells[indexPath.row]
        cell.action?(cell)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableviewSections[section].title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.text = tableviewSections[section].title
            headerView.textLabel?.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize, weight: .bold)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .secondarySystemBackground
    }
}
