//
//  RangeConverterHelper.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 19/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct RangeConverterHelper {
    
    static let shared = RangeConverterHelper()
    private init() { }
    
    /// Linear conversion in Swift. Converting a value from the old range to the new range.
    /// Example: get the value from an old range of 0 - 10 to a new range of 0 - 1
    /// - Parameters:
    ///   - oldValue: The old value. This value will then be converted to the enw range value.
    ///   - oldRange: The old range array. MUST be only consisting of 2 value. [oldMin, oldMax]
    ///   - newRange: The new range arary. MUSt be only consisting of 2 value. [newMin, newMax]
    /// - Returns: <#description#>
    func convert(_ oldValue: Float, fromOldRange oldRange: [Float], toNewRange newRange: [Float]) -> Float {
        guard oldRange.count == 2, newRange.count == 2 else { fatalError("The ranges must only consist of 2 value.") }
        
        let oldRangeDiff = oldRange[1] - oldRange[0]
        let newRangeDiff = newRange[1] - newRange[0]
        
        let a = (oldValue - oldRange[0]) * newRangeDiff
        return (a / oldRangeDiff) + newRange[0]
    }
}
