//
//  testTicker.swift
//  tickTests
//
//  Created by Martin Calvert on 7/1/18.
//  Copyright © 2018 Martin Calvert. All rights reserved.
//

import XCTest
@testable import tick

class TestTicker: XCTestCase {
    private var ticker: Ticker!

    override func setUp() {
        super.setUp()
        ticker = Ticker(date: Date(timeInterval: 10.0, since: Date()), name: "test")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testName() {
        XCTAssertEqual("test", ticker.name)
    }

    func testTimeTill() {
        XCTAssertTrue(ticker.timeTill.contains("seconds until"))

        ticker.date.addTimeInterval(70.0)
        XCTAssertTrue(ticker.timeTill.elementsEqual("1 minute until"))

        ticker.date.addTimeInterval(70.0)
        XCTAssertTrue(ticker.timeTill.elementsEqual("2 minutes until"))

        ticker.date.addTimeInterval(4000.0)
        XCTAssertTrue(ticker.timeTill.elementsEqual("1 hour until"))

        ticker.date.addTimeInterval(4000.0)
        XCTAssertTrue(ticker.timeTill.elementsEqual("2 hours until"))

        ticker.date.addTimeInterval(90000.0)
        XCTAssertTrue(ticker.timeTill.elementsEqual("1 day until"))

        ticker.date.addTimeInterval(90000.0)
        XCTAssertTrue(ticker.timeTill.elementsEqual("2 days until"))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
