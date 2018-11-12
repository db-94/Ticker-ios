//
//  TickerTableViewCellTests.swift
//  tickTests
//
//  Created by Martin Calvert on 11/9/18.
//  Copyright © 2018 Martin Calvert. All rights reserved.
//

import XCTest
@testable import tick

class TickerTableViewCellTests: XCTestCase {
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
        tickerTable.tableView.numberOfRows(inSection: 0)
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

    func testPinkCell() {
        if let cell = tickerTable!.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TickerTableViewCell {
            XCTAssertEqual(UIColor(named: tick.Constants.pink.rawValue), cell.backgroundColor)
            XCTAssertEqual(tickers[0].name, cell.label.text!)
            XCTAssertEqual(tickers[0].dateTimeString, cell.date.text!)
            XCTAssertEqual(tickers[0].timeTill, cell.timeTill.text!)
        }
    }

    func testTealCell() {
        if let cell = tickerTable!.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TickerTableViewCell {
            XCTAssertEqual(UIColor(named: tick.Constants.teal.rawValue), cell.backgroundColor)
            XCTAssertEqual(tickers[1].name, cell.label.text!)
            XCTAssertEqual(tickers[1].dateTimeString, cell.date.text!)
            XCTAssertEqual(tickers[1].timeTill, cell.timeTill.text!)
        }
    }

    func testPurpleCell() {
        if let cell = tickerTable!.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? TickerTableViewCell {
            XCTAssertEqual(UIColor(named: tick.Constants.purple.rawValue), cell.backgroundColor)
            XCTAssertEqual(tickers[2].name, cell.label.text!)
            XCTAssertEqual(tickers[2].dateTimeString, cell.date.text!)
            XCTAssertEqual(tickers[2].timeTill, cell.timeTill.text!)
        }
    }
}
