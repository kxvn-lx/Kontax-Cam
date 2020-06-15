//
//  DatestampLabel.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 15/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class DatestampLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        self.font = UIFont(name: "Date Stamp", size: UIFont.preferredFont(forTextStyle: .title3).pointSize)
        self.textColor = UIColor(displayP3Red: 249/255, green: 148/255, blue: 60/255, alpha: 1)
        self.text = getCurrentDate()
    }
    
    func applyGlow() {
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.masksToBounds = false
        self.alpha = 0.5
    }
    
    private func getCurrentDate() -> String {
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [.year, .month, .day]

        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)

        let year = String(dateTimeComponents.year!).dropFirst(2)
        let month = String(dateTimeComponents.month!)
        let day = String(dateTimeComponents.day!)
        
        return "\(day)  \(month) '\(year)"
    }

}
