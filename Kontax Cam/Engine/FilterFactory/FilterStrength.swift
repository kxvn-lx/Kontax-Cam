//
//  FilterStrength.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 20/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

struct FilterStrength {
    
    static var strengthMap: [FilterType: CGFloat] = [.grain: 10.0,
                                                     .colourleaks: 10.0,
                                                     .dust: 10.0,
                                                     .lightleaks: 10.0]
    
    private init() { }
}
