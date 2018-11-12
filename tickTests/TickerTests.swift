//
//  testTicker.swift
//  tickTests
//
//  Created by Martin Calvert on 7/1/18.
//  Copyright © 2018 Martin Calvert. All rights reserved.
//

import XCTest
@testable import tick

class TickerTest: XCTestCase {
    private var ticker: Ticker!
    private let tickerName = "test"
    private let tickerDate = Date(timeInterval: 10.0, since: Date())
    private let tickerColor = tick.Constants.pink.rawValue
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d yyyy"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }()

    private let dateTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d yyyy hh:mmaaa"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }()

    private let timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mmaa"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }()

    override func setUp() {
        super.setUp()
        ticker = Ticker(date: tickerDate, name: tickerName, color: tickerColor)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testTickerName() {
        XCTAssertEqual(tickerName, ticker.name)
    }

    func testTickerDate() {
        XCTAssertEqual(tickerDate, ticker.date)
    }

    func testTickerColor() {
        XCTAssertEqual(tickerColor, ticker.color)
    }

    func testTickerDateString() {
        XCTAssertEqual(dateFormatter.string(from: tickerDate), ticker.dateString)
    }

    func testTickerDateTimeString() {
        XCTAssertEqual(dateTimeFormatter.string(from: tickerDate), ticker.dateTimeString)
    }

    func testTickerTimeString() {
        XCTAssertEqual(timeFormatter.string(from: tickerDate), ticker.timeString)
    }

    func testDateFormatter() {
        XCTAssertEqual(dateFormatter.dateFormat, Ticker.dateFormatter.dateFormat)
    }

    func testDateTimeFormatter() {
        XCTAssertEqual(dateTimeFormatter.dateFormat, Ticker.dateTimeFormatter.dateFormat)
    }

    func testTimeFormatter() {
        XCTAssertEqual(timeFormatter.dateFormat, Ticker.timeFormatter.dateFormat)
    }

    func testEquals() {
        let ticker2 = Ticker(date: tickerDate, name: tickerName, color: tickerColor)
        XCTAssertEqual(ticker2, ticker)
    }

    func testToFromJson() {
        let json = ticker.json
        let newTicker = Ticker.init(json: json!)

        XCTAssertNotNil(newTicker)
        XCTAssertEqual(ticker, newTicker!)
    }

    func testDateYears() {
        XCTAssertNotNil(tickerDate.years(from: Date()))
    }

    func testDateMonths() {
        XCTAssertNotNil(tickerDate.months(from: Date()))
    }

    func testDateDays() {
        XCTAssertNotNil(tickerDate.days(from: Date()))
    }

    func testDateHours() {
        XCTAssertNotNil(tickerDate.hours(from: Date()))
    }

    func testDateMinutes() {
        XCTAssertNotNil(tickerDate.minutes(from: Date()))
    }

    func testDateSeconds() {
        XCTAssertNotNil(tickerDate.seconds(from: Date()))
    }

    func testDateNanoSeconds() {
        XCTAssertNotNil(tickerDate.nanoseconds(from: Date()))
    }

    func testDateWeeks() {
        XCTAssertNotNil(tickerDate.weeks(from: Date()))
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
}
