//
//  KontaxCam_UnitTest.swift
//  KontaxCam_UnitTest
//
//  Created by Kevin Laminto on 19/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import XCTest
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
    
}
