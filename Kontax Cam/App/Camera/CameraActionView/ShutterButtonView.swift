//
//  ShutterButtonView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SnapKit

class ShutterButtonView: UIView {

    private let animationDuration: TimeInterval = 0.05
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // View configuration
        self.isUserInteractionEnabled = true
        
        // View UI
        self.backgroundColor = UIColor.systemGray6
        self.layer.cornerRadius = frame.width / 2
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.snp.makeConstraints { (make) in
            make.height.width.equalTo(frame.width)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Touch event listener
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.backgroundColor = UIColor.systemGray6
            UIView.animate(withDuration: self.animationDuration) {
                self.backgroundColor = UIColor.systemGray5
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.backgroundColor = UIColor.systemGray5
            UIView.animate(withDuration: self.animationDuration) {
                self.backgroundColor = UIColor.systemGray6
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.backgroundColor = UIColor.systemGray5
            UIView.animate(withDuration: self.animationDuration) {
                self.backgroundColor = UIColor.systemGray6
            }
        }
    }

}
