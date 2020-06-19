//
//  Kontax_CamTests.swift
//  Kontax CamTests
//
//  Created by Kevin Laminto on 19/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import XCTest
import Foundation
@testable import Kontax_Cam

class KontaxCam_UnitTest: XCTestCase {
    
    var sut: RangeConverterHelper!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = RangeConverterHelper.shared
    }
    
    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func testRangeConverter() {
        // 1. Given
        let oldValue: Float = 5
        let resultValue: Float = 0.5
        
        // 2. When
        let guess: Float = sut.convert(oldValue, fromOldRange: [0, 10], toNewRange: [0, 1])
        
        // 3. Then
        XCTAssertEqual(guess, resultValue, "RangeConverter should follow Linear Conversion pattern!")
    }
    
    
}
