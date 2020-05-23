//
//  TimerAction.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 23/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SPAlert

class TimerAction: UIButton {
    
    static var timeEngine = TimerEngine()
    private var spAlert: SPAlertView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(IconHelper.shared.getIcon(iconName: .timer, currentIcon: nil).0, for: .normal)
        self.addTarget(self, action: #selector(timerTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func timerTapped() {
        TapticHelper.shared.lightTaptic()
        
        if spAlert != nil { spAlert.dismiss() }
        let time = TimerAction.timeEngine.ToggleTimer()
        let message = time == 0 ? "Timer: Off" : "Timer: \(time) seconds"
        spAlert = SPAlertView(title: message, message: nil, image: IconHelper.shared.getIcon(iconName: .timer, currentIcon: nil).0)
        
        spAlert.present()
    }

}
