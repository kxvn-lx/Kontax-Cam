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
    
    private let timer = ["timer"]
    
    static var timeEngine = TimerEngine()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(getIcon(), for: .normal)
        self.addTarget(self, action: #selector(timerTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func timerTapped() {
        TapticHelper.shared.lightTaptic()
        
        let time = TimerAction.timeEngine.ToggleTimer()
        let title = time == 0 ? "Timer: Off" : "Timer: \(time) seconds"
        SPAlertHelper.shared.present(title: title, message: nil, image: getIcon())
    }
    
    private func getIcon() -> UIImage {
        return IconHelper.shared.getIconImage(iconName: timer[0])
    }

}
