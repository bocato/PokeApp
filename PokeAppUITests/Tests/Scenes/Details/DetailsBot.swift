//
//  DetailsBot.swift
//  PokeAppUITests
//
//  Created by Eduardo Bocato on 15/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

import XCTest

class DetailsBot {
    
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
        return app.descendantElement(with: "details.views.root")
    }()
    
    /// Labels
    /// Buttons
    private lazy var addOrRemoveFavoriteButton: XCUIElement = {
        let button = app.descendantElement(with: "details.buttons.addRemoveFavorite")
        let buttonExists = button.waitForExistence(timeout: 1.0)
        XCTAssert(buttonExists, "AddOrRemoveFavorite button does not exist")
        return button
    }()
    
    /// Textfields
    /// Images
    /// Other elements
    
    // MARK: - Actions
    @discardableResult
    func takeScreenShot(_ activity: XCTActivity, _ name: String = "Screenshot", _ lifetime: XCTAttachment.Lifetime = .keepAlways) -> Self {
        testCase.takeScreenshot(activity: activity, name, lifetime)
        return self
    }
    
    @discardableResult
    func tapAddOrRemoveFavoriteButton() -> Self {
        addOrRemoveFavoriteButton.tap()
        return self
    }
    
    // MARK: - Flows
    
    // MARK: - UI Validations
    @discardableResult
    public func checkAddFavoriteExists() -> Self {
        let buttonLabel = addOrRemoveFavoriteButton.label
        XCTAssertEqual(buttonLabel, "Add to Favorites", "Invalid button state")
        return self
    }
    
    @discardableResult
    public func checkRemoveFromFavoritesExists() -> Self {
        let buttonLabel = addOrRemoveFavoriteButton.label
        XCTAssertEqual(buttonLabel, "Remove from Favorites", "Invalid button state")
        return self
    }
    
    @discardableResult
    public func waitToReachHome() -> Self {
        let homeRootView = app.descendantElement(with: "home.views.root")
        let homeRootViewExists = homeRootView.waitForExistence(timeout: 1.0)
        XCTAssert(homeRootViewExists, "Did not reach Home")
        return self
    }
    
    @discardableResult
    public func checkIfContainsLabelWithText(_ text: String) -> Self {
        let labelWithText = app.descendantElement(with: text)
        let labelWithTextExists = labelWithText.waitForExistence(timeout: 1.0)
        XCTAssertTrue(labelWithTextExists, "Label containing \(text) does not exists")
        return self
    }
    
}
