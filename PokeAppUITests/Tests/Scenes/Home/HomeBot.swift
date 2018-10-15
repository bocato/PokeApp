//
//  HomeBot.swift
//  PokeAppUITests
//
//  Created by Eduardo Bocato on 15/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest

class HomeBot {
    
    // MARK: Properties
    private let app: XCUIApplication
    private let testCase: XCTestCase
    
    // MARK: - Lifecycle
    required init(on app: XCUIApplication, for testCase: XCTestCase, wait timeout: TimeInterval = 1) {
        self.app = app
        self.testCase = testCase
        let rootViewExists = rootView.waitForExistence(timeout: timeout)
        XCTAssertTrue(rootViewExists, "\(String(describing: self)) not loaded in time")
    }
    
    // MARK: UIElements
    /// Views
    private lazy var rootView: XCUIElement = {
        return app.descendantElement(with: "home.views.root")
    }()
    
    /// Labels
    /// Buttons
    /// Textfields
    /// Images
    
    /// Other elements
    private lazy var tableView: XCUIElement = {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists, "TableView dos not exist")
        return tableView
    }()
    
    // MARK: - Actions
    @discardableResult
    public func takeScreenShot(_ activity: XCTActivity, _ name: String = "Screenshot", _ lifetime: XCTAttachment.Lifetime = .keepAlways) -> Self {
        testCase.takeScreenshot(activity: activity, name, lifetime)
        return self
    }
    
    @discardableResult
    public func tapCell(with text: String) -> Self {
        let cellWithText = tableView.cells.containing(.staticText, identifier: text).firstMatch
        XCTAssert(cellWithText.exists, "Cell containing \(text) does not exist")
        cellWithText.tap()
        return self
    }
    
    @discardableResult
    public func tapTab(with text: String) -> Self {
        let tabWithText = app.tabBars.buttons[text]
        XCTAssert(tabWithText.exists, "Tab containing \(text) does not exist")
        tabWithText.tap()
        return self
    }
    
    // MARK: - Flows
    
    // MARK: - UI Validations
    
}
