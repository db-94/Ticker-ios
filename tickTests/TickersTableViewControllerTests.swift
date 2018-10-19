//
//  tickTests.swift
//  tickTests
//
//  Created by Martin Calvert on 7/1/18.
//  Copyright © 2018 Martin Calvert. All rights reserved.
//

import XCTest
@testable import tick

class TickersTableViewControllerTests: XCTestCase {

    private var storyboard: UIStoryboard!
    private var navCon: UINavigationController!
    private var tickerTable: TickersTableViewController!
    private var tickers = [Ticker]()
    private var actualUrl: URL!
    private var tempUrl: URL!

    override func setUp() {
        super.setUp()

        tickers.append(Ticker(date: Date(), name: "first", color: tick.Constants.pink.rawValue)!)
        tickers.append(Ticker(date: Date(), name: "second", color: tick.Constants.teal.rawValue)!)
        tickers.append(Ticker(date: Date(), name: "third", color: tick.Constants.purple.rawValue)!)

        let jsonData = try? JSONEncoder().encode(tickers)

        do {
            actualUrl = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
                ).appendingPathComponent("user.json")

            tempUrl = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
                ).appendingPathComponent("user.temp.json")

            try FileManager.default.moveItem(at: actualUrl, to: tempUrl)
        } catch let error {
            print(error)
        }

        if let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("user.json") {
            do {
                try jsonData?.write(to: url)
            } catch let error {
                print(error)
            }
        }

        storyboard = UIStoryboard(name: "Main", bundle: nil)
        navCon = storyboard.instantiateInitialViewController() as? UINavigationController
        tickerTable = navCon!.topViewController as? TickersTableViewController
        _ = tickerTable.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

        do {
            try FileManager.default.moveItem(at: tempUrl, to: actualUrl)
        } catch let error {
            print(error)
        }
    }

    func testNavTitle() {
        XCTAssertEqual("Ticker", tickerTable!.navigationItem.title)
    }

    func testTableViewSections() {
        XCTAssertEqual(1, tickerTable!.tableView.numberOfSections)
    }

    func testTableViewRowsEqualToTickers() {
        XCTAssertEqual(tickers.count, tickerTable.tableView.numberOfRows(inSection: 0))
    }

    func testTableViewRowColor() {
        tickerTable.tableView.numberOfRows(inSection: 0)
        let pinkRow = tickerTable!.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        let tealRow = tickerTable!.tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        let purpleRow = tickerTable!.tableView.cellForRow(at: IndexPath(row: 2, section: 0))

        XCTAssertEqual(UIColor(named: tick.Constants.pink.rawValue), pinkRow?.backgroundColor)
        XCTAssertEqual(UIColor(named: tick.Constants.teal.rawValue), tealRow?.backgroundColor)
        XCTAssertEqual(UIColor(named: tick.Constants.purple.rawValue), purpleRow?.backgroundColor)
    }
}
