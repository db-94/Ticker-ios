//
//  TickerViewController.swift
//  tickTests
//
//  Created by Martin Calvert on 11/12/18.
//  Copyright © 2018 Martin Calvert. All rights reserved.
//

import XCTest
@testable import tick

class TickerViewControllerTests: XCTestCase {
    private var storyboard: UIStoryboard!
    private var navCon: UINavigationController!
    private var tickerVC: TickerViewController!
    private let tickerDate = Date(timeInterval: 10.0, since: Date())
    private let tickerName = "test"
    private let tickerColor = tick.Constants.purple.rawValue
    private var ticker: Ticker!

    override func setUp() {
        super.setUp()

        storyboard = UIStoryboard(name: "Main", bundle: nil)
        tickerVC = storyboard.instantiateViewController(withIdentifier: "tickerViewController") as? TickerViewController
        _ = tickerVC.view

        ticker = Ticker(date: tickerDate, name: tickerName, color: tickerColor)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testColorButtonsCount() {
        XCTAssertEqual(4, tickerVC.colorButtons.count)
    }

    func testColorButtonsOrder() {
        XCTAssertEqual(tickerVC.tealButton, tickerVC.colorButtons[0])
        XCTAssertEqual(tickerVC.purpleButton, tickerVC.colorButtons[1])
        XCTAssertEqual(tickerVC.pinkButton, tickerVC.colorButtons[2])
        XCTAssertEqual(tickerVC.blackButton, tickerVC.colorButtons[3])
    }

    func testBlackButtonsTitles() {
        verifyButton(button: tickerVC.blackButton, title: "Black")
    }

    func testTealButtonsTitles() {
        verifyButton(button: tickerVC.tealButton, title: "Teal")
    }

    func testPinkButtonsTitles() {
        verifyButton(button: tickerVC.pinkButton, title: "Pink")
    }

    func testPurpleButtonsTitles() {
        verifyButton(button: tickerVC.purpleButton, title: "Purple")
    }

    func testTouchesBegan() {
        tickerVC.datePicker.isHidden = false
        tickerVC.timePicker.isHidden = false
        tickerVC.titleField.becomeFirstResponder()

        tickerVC.touchesBegan(Set(), with: nil)

        XCTAssertTrue(tickerVC.datePicker.isHidden)
        XCTAssertTrue(tickerVC.timePicker.isHidden)
        XCTAssertFalse(tickerVC.titleField.isFirstResponder)
    }

    func testLoadTimePicker() {
        tickerVC.titleField.becomeFirstResponder()
        tickerVC.datePicker.isHidden = false
        tickerVC.timePicker.isHidden = true

        tickerVC.loadTimePicker(tickerVC.timePicker)

        XCTAssertFalse(tickerVC.timePicker.isHidden)
        XCTAssertTrue(tickerVC.datePicker.isHidden)
        XCTAssertFalse(tickerVC.titleField.isFirstResponder)
    }

    func testLoadDatePicker() {
        tickerVC.titleField.becomeFirstResponder()
        tickerVC.datePicker.isHidden = true
        tickerVC.timePicker.isHidden = false

        tickerVC.loadDatePicker(tickerVC.timePicker)

        XCTAssertTrue(tickerVC.timePicker.isHidden)
        XCTAssertFalse(tickerVC.datePicker.isHidden)
        XCTAssertFalse(tickerVC.titleField.isFirstResponder)
    }

    func testViewDidLoad() {
        tickerVC.datePicker.datePickerMode = .time
        tickerVC.timePicker.datePickerMode = .date
        tickerVC.viewDidLoad()

        XCTAssertEqual(tickerVC.datePicker.datePickerMode, .date)
        XCTAssertEqual(tickerVC.timePicker.datePickerMode, .time)
    }

    func testUpdateUI() {
        tickerVC.ticker = ticker
        tickerVC.updateUI()

        XCTAssertEqual(tickerName, tickerVC.titleField.text)
        XCTAssertTrue(tickerVC.purpleButton.isSelected)
        XCTAssertEqual(tickerDate, tickerVC.datePicker.date)
        XCTAssertEqual(tickerDate, tickerVC.timePicker.date)
        XCTAssertEqual(ticker.dateString, tickerVC.dateField.titleLabel!.text!)
        XCTAssertEqual(ticker.timeString, tickerVC.timeField.titleLabel!.text!)
    }

    func testShouldResign() {
        tickerVC.titleField.becomeFirstResponder()
        XCTAssertFalse(tickerVC.textFieldShouldReturn(tickerVC.titleField))
        XCTAssertFalse(tickerVC.titleField.isFirstResponder)
    }

    func testNameShouldClear() {
        tickerVC.titleField.text = "Name"
        tickerVC.clearIfName(tickerVC.titleField)

        XCTAssertEqual("", tickerVC.titleField.text!)
    }

    func testPrepareForSegue() {
        tickerVC.titleField.text = "test"
        tickerVC.datePicker.date = tickerDate
        tickerVC.timePicker.date = tickerDate

        let segue = UIStoryboardSegue(identifier: "save", source: tickerVC, destination: tickerVC)

        tickerVC.prepare(for: segue, sender: nil)

        XCTAssertEqual("test", tickerVC.ticker?.name)
        XCTAssertEqual(tick.Constants.teal.rawValue, tickerVC.ticker?.color)
    }

    func verifyButton(button: UIButton, title: String) {
        XCTAssertFalse(button.isSelected)
        let notSelected = button.titleLabel?.text!
        XCTAssertEqual(title, notSelected)

        tickerVC.chooseColor(button)

        let selected = button.title(for: .selected)
        XCTAssertTrue(button.isSelected)
        XCTAssertEqual("✔️", selected)

        let actions = button.actions(forTarget: tickerVC.self, forControlEvent: UIControl.Event.touchUpInside)
        XCTAssertEqual(1, actions?.count)
        XCTAssertEqual("chooseColor:", actions?.first!)
    }
}
