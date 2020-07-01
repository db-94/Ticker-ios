//
//  tickUITests.swift
//  tickUITests
//
//  Created by Martin Calvert on 4/5/20.
//  Copyright © 2020 Martin Calvert. All rights reserved.
//

import XCTest

class TickUITests: XCTestCase {

    override func setUpWithError() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHeaderExists() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        existsAndHittable(element: app.images["header"])
    }

    func testPlusButtonExists() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        existsAndHittable(element: app.buttons["+"])
    }

    func testPlusButtonLeadsToModal() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        app.buttons["+"].tap()
        existsAndHittable(element: app.textFields["Name"])
        existsAndHittable(element: app.staticTexts["Date"])
        existsAndHittable(element: app.staticTexts["Time"])

        let datepickers = app.datePickers.allElementsBoundByIndex

        existsAndHittable(element: datepickers[0])
        existsAndHittable(element: datepickers[1])

        existsAndHittable(element: app.buttons["Save"])

        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("Vacation \n")

        snapshot("createScreen")
        app.buttons["Save"].tap()

        snapshot("homeScreen")
    }

    func existsAndHittable(element: XCUIElement) {
        XCTAssert(element.exists)
        XCTAssert(element.isHittable)
    }
}
