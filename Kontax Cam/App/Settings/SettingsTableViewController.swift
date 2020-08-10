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
        static let appIconsCell = IndexPath(row: 1, section: 0)
        static let deleteImagesCell = IndexPath(row: 0, section: 1)
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
        case CellPath.deleteImagesCell: self.deleteImagesCellTapped()
        case CellPath.appIconsCell: self.appIconsCellTapped()
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath {
        case CellPath.deleteImagesCell: cell.textLabel?.textColor = .systemRed
        default: break
        }
        cell.backgroundColor = .systemGray6
    }
    
    private func setupUI() {
        let closeButton = CloseButton()
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        self.tableView.backgroundColor = .systemBackground
        
        self.tableView.tableFooterView = SettingsFooterView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 150))
    }
    
    @objc private func closeTapped() {
        dismissWithAnimation()
    }
    
}

extension SettingsTableViewController {
    
    // MARK: - onCellTapped event Listener
    private func appearanceCellTapped() {
        let vc = AppearanceTableViewController()
        let navController = PanModalNavigationController(rootViewController: vc)
        self.presentPanModal(navController)
    }
    
    private func deleteImagesCellTapped() {
        let alert = UIAlertController(title: "Delete all lab images?", message: "This will free up some space in your device.", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
            guard let self = self else { return }
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
                for fileURL in fileURLs { try FileManager.default.removeItem(at: fileURL) }
                
                AlertHelper.shared.presentDefault(title: "Lab images has been successfully deleted.", message: nil, to: self)
            } catch { print(error) }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func appIconsCellTapped() {
        let vc = AppIconsTableViewController(style: .insetGrouped)
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
}
