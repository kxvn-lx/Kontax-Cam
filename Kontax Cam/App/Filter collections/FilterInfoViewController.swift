//
//  FilterInfoViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 16/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class FilterInfoViewController: UIViewController {
    
    var selectedCollection: FilterCollection! {
        didSet {

        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle("")
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .systemBackground
        
        setupView()
        setupConstraint()
    }
    
    private func setupView() {

    }
    
    private func setupConstraint() {

    }
    
}
