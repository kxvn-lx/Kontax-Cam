//
//  FilterAction.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 23/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit


class FilterAction: UIButton {

    private let filter = ["paintbrush.fill"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(getIcon(), for: .normal)
        self.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func filterTapped() {
        TapticHelper.shared.lightTaptic()
        NotificationCenter.default.post(name: .filterList, object: nil)
    }
    
    private func getIcon() -> UIImage {
        return IconHelper.shared.getIconImage(iconName: filter[0])
    }
    
    

}
