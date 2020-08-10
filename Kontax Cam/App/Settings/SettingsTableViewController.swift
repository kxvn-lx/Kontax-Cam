//
//  SettingsTableViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 12/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class SettingsTableViewController: UITableViewController {
    
    private struct CellPath {
        static let appearanceCell = IndexPath(row: 0, section: 0)
        static let appIconsCell = IndexPath(row: 1, section: 0)
        static let deleteImagesCell = IndexPath(row: 0, section: 2)
        static let sourceCodeCell = IndexPath(row: 0, section: 1)
        static let twitterCell = IndexPath(row: 1, section: 1)
        static let emailCell = IndexPath(row: 2, section: 1)
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
        case CellPath.sourceCodeCell: self.sourceCodeCellTapped()
        case CellPath.twitterCell: self.twitterCellTapped()
        case CellPath.emailCell: self.reportABugCellTapped()
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
    
    private func twitterCellTapped() {
        if let url = URL(string: "https://twitter.com/kevinlx_") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let sfSafariVC = SFSafariViewController(url: url)
                present(sfSafariVC, animated: true)
            }
        }
    }
    
    private func sourceCodeCellTapped() {
        if let url = URL(string: "https://github.com/kxvn-lx/Kontax-Cam") {
            let sfSafariVC = SFSafariViewController(url: url)
            present(sfSafariVC, animated: true)
        }
    }
    
    private func reportABugCellTapped() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["kevinlaminto.dev@gmail.com"])
            mail.setSubject("[Kontax-Cam] Hi there! ✉️")
            
            present(mail, animated: true)
        } else {
            AlertHelper.shared.presentDefault(title: "No mail account.", message: "Please configure a mail account in order to send email. Or, manually email it to kevinlaminto.dev@gmail.com", to: self)
        }

    }
}

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
