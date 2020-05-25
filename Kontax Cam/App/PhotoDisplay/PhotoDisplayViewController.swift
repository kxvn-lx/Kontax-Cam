//
//  PhotoDisplayViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 24/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class PhotoDisplayViewController: UIViewController {
    
    let imageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        self.configureNavigationBar(backgoundColor: .secondarySystemBackground, tintColor: .label, title: "", preferredLargeTitle: false)
        
        let close = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
        

        setupUI()
        setupConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isToolbarHidden = true
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.view.addSubview(imageView)
        
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTapped))
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let items = [share, flexible, save, flexible, delete]
        for item in items {
            item.tintColor = .label
        }

        self.toolbarItems = items
    }
    
    private func setupConstraint() {
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width * 0.9)
            make.height.equalTo(self.view.frame.height * 0.7)
            make.center.equalToSuperview()
        }
    }
    
    @objc func addItem() {
        print("Adding...")
    }
    
    @objc private func shareTapped() {
        print("Sharing")
    }
    
    @objc private func saveTapped() {
        print("Saving")
    }
    
    @objc private func deleteTapped() {
        print("Deleting")
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
