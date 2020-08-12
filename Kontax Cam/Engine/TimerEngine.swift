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
    mutating func ToggleTimer() {
        var nextIndex = allowedTime.firstIndex(of: currentTime)! + 1
        nextIndex = nextIndex >= allowedTime.count ? 0 : nextIndex
        currentTime = allowedTime[nextIndex]
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
            make.center.equalToSuperview()
        }
        
        var time = currentTime!
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            timeLabel.alpha = 0
            time -= 1
            DispatchQueue.main.async {
                timeLabel.text = "\(time)"
                
                UIView.animate(
                    withDuration: 0.25,
                    animations: {
                        timeLabel.alpha = 1
                },
                    completion: nil)
                
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(currentTime) - 0.5) {
            v.removeFromSuperview()
            timer.invalidate()
        }
    }
}
