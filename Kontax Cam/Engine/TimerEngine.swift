//
//  TimerEngine.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

struct TimerEngine {
    
    private let allowedTime = [0, 3, 5]
    var currentTime: Int!
    
    init() {
        currentTime = allowedTime[0]
    }
    
    /// Toggle the timer (Switching between the states)
    /// - Returns: The timer in Int (seconds)
    mutating func ToggleTimer() -> Int {
        var nextIndex = allowedTime.firstIndex(of: currentTime)! + 1
        nextIndex = nextIndex >= allowedTime.count ? 0 : nextIndex
        currentTime = allowedTime[nextIndex]
        
        return currentTime
    }
    
    /// Present the timer to the key window
    func presentTimerDisplay() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        let v = UIView(frame: window.bounds)
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = String(currentTime)
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center
        timeLabel.font = timeLabel.font.makeRoundedFont(ofSize: .largeTitle, multiplier: 4, weight: .medium)
        
        window.addSubview(v)
        v.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(v)
            make.centerY.equalTo(v).offset(-80)
        }
        
        var time = currentTime!
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            DispatchQueue.main.async {
                time -= 1
                timeLabel.text = "\(time)"
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(currentTime) - 0.5) {
            v.removeFromSuperview()
            timer.invalidate()
        }
    }
}
