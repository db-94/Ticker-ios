//
//  tickTests.swift
//  tickTests
//
//  Created by Martin Calvert on 7/1/18.
//  Copyright © 2018 Martin Calvert. All rights reserved.
//

import XCTest
@testable import tick

class TickTableViewTests: XCTestCase {

    private var storyboard: UIStoryboard!
    private var navCon: UINavigationController!
    private var tickerTable: TickersTableViewController!

    override func setUp() {
        super.setUp()

        storyboard = UIStoryboard(name: "Main", bundle: nil)
        navCon = storyboard.instantiateInitialViewController() as? UINavigationController
        tickerTable = navCon!.topViewController as? TickersTableViewController
        _ = tickerTable.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNavTitle() {
        XCTAssertEqual("Ticker", tickerTable!.navigationItem.title)
    }

    func testTableViewSections() {
        XCTAssertEqual(1, tickerTable!.tableView.numberOfSections)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
