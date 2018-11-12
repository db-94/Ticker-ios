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
    private var oldTickers = [Ticker]()

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
        } catch let error {
            print(error)
        }

        if let json = try? Data(contentsOf: actualUrl) {
            if let arr = try? JSONDecoder().decode(Array<Ticker>.self, from: json) {
                oldTickers = arr
            }
        }

        do {
            try jsonData?.write(to: actualUrl)
        } catch let error {
            print(error)
        }

        storyboard = UIStoryboard(name: "Main", bundle: nil)
        navCon = storyboard.instantiateInitialViewController() as? UINavigationController
        tickerTable = navCon!.topViewController as? TickersTableViewController
        _ = tickerTable.view
    }

    override func tearDown() {
        super.tearDown()

        do {
            let jsonData = try? JSONEncoder().encode(oldTickers)
            try jsonData?.write(to: actualUrl)
        } catch let error {
            print(error)
        }
    }

    func testNavTitle() {
        XCTAssertEqual("Ticker", tickerTable!.navigationItem.title)
    }

    func testAddButtonIsPresent() {
        let addButton = tickerTable.navigationItem.rightBarButtonItems?[0]
        XCTAssertNotNil(addButton)
        XCTAssertEqual(addButton?.tintColor, UIColor.white)
    }

    func testBackButtonIsNotPresent() {
        let addButton = tickerTable.navigationItem.leftBarButtonItems?[0]
        XCTAssertNil(addButton)
    }

    func testTableViewSections() {
        XCTAssertEqual(1, tickerTable!.tableView.numberOfSections)
    }

    func testTableViewRowsEqualToTickers() {
        XCTAssertEqual(tickers.count, tickerTable.tableView.numberOfRows(inSection: 0))
    }

    func testSave() {
        tickerTable.save()
        XCTAssertNotNil(try Data(contentsOf: actualUrl))
    }

    func testUnwindFromNew() {
        let tickerVC = storyboard.instantiateViewController(withIdentifier: "tickerViewController") as? TickerViewController
        let newTicker = Ticker(date: Date(), name: "fourth", color: tick.Constants.black.rawValue)!
        let count = tickerTable.tickers.count
        tickerVC?.ticker = newTicker
        let segue = UIStoryboardSegue(identifier: "new", source: tickerVC!, destination: tickerTable)

        tickerTable.unwwindFromNew(segue)

        XCTAssertEqual(count + 1, tickerTable.tickers.count)
        XCTAssertEqual("fourth", tickerTable.tickers[3].name)
    }
}
