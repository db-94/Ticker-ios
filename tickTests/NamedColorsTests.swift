//
//  NamedColorsTests.swift
//  tickTests
//
//  Created by Martin Calvert on 10/18/18.
//  Copyright © 2018 Martin Calvert. All rights reserved.
//

import XCTest
@testable import tick

class NamedColorsTests: XCTestCase {
    func testPinkColor() {
        XCTAssertNotNil(UIColor(named: tick.Constants.pink.rawValue))
    }

    func testPurpleColor() {
        XCTAssertNotNil(UIColor(named: tick.Constants.purple.rawValue))
    }

    func testTealColor() {
        XCTAssertNotNil(UIColor(named: tick.Constants.teal.rawValue))
    }

    func testWhiteColor() {
        XCTAssertNotNil(UIColor(named: tick.Constants.white.rawValue))
    }

    func testBlackColor() {
        XCTAssertNotNil(UIColor(named: tick.Constants.black.rawValue))
    }
}
