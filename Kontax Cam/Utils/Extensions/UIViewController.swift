//
//  UIViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 15/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

extension UIViewController {
    func addCloseButton() {
        let closeButton = CloseButton()
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func setNavigationBarTitle(
        _ title: String,
        backgroundColor: UIColor = .systemBackground,
        preferredLargeTitle: Bool = false,
        tintColor: UIColor = .label,
        titleColor: UIColor = .label,
        removeSeparator: Bool = true) {
        navigationItem.title = title
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
        navBarAppearance.titleTextAttributes = [.foregroundColor: titleColor]
        navBarAppearance.backgroundColor = backgroundColor
        navBarAppearance.shadowColor = removeSeparator ? .clear : .quaternaryLabel
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColor
    }
    
    func addVC(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeVC() {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
