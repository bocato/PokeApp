//
//  AddAndRemoveFavoritesFlowTests.swift
//  PokeAppUITests
//
//  Created by Eduardo Bocato on 15/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest

class AddAndRemoveFavoritesFlowTests: XCTestCase {

    // MARK: - Properties
    var app: XCUIApplication!
    var homeBot: HomeBot!
    var detailsBot: DetailsBot?
    var favoritesBot: FavoritesBot?
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        homeBot = HomeBot(on: app, for: self, wait: 1.0)
    }
    
    override func tearDown() {
        super.tearDown()
        detailsBot = nil
        favoritesBot = nil
        URLSession.removeAllMocks()
    }
    
    private func mockPokemonList() {
        let pokemons = MockDataHelper.getData(forResource: .pokemonList)
        do {
            try URLSession.mockNext(expression: "/pokemon/", body: pokemons)
        } catch let error {
            XCTFail("Could not mock pokemonList, error: \(error.localizedDescription)")
        }
    }
    
    private func mockBulbassaur() {
        let bulbassaur = MockDataHelper.getData(forResource: .pokemonList)
        do {
            try URLSession.mockNext(expression: "/pokemon/1", body: bulbassaur)
        } catch let error {
            XCTFail("Could not mock bulbassaur, error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Tests
    func testAddToFavoritesWithBots() {
        
        mockPokemonList()
        mockBulbassaur()
        
        group("Given the Home View is loaded") { (activity) in
            homeBot
                .takeScreenShot(activity, "Home Loaded")
                .tapCell(with: "#1: Bulbasaur")
        }
        
        group("Selected #1: Bulbasaur") { (activity) in
            detailsBot = DetailsBot(on: app, for: self, wait: 1.0)
            detailsBot?
                .takeScreenShot(activity, "DetailsReached")
                .checkAddFavoriteExists()
                .tapAddOrRemoveFavoriteButton()
                .waitToReachHome()
            
        }
        
        group("Check if Favorites contain Bulbassaur") { (activity) in

            homeBot.tapTab(with: "Favorites")
            
            favoritesBot = FavoritesBot(on: app, for: self, wait: 1.0)
            favoritesBot?
                .takeScreenShot(activity, "Reached Favorites")
                .checkIfContainsCell(with: "Bulbasaur")
                .tapCell(with: "Bulbasaur")
            
            detailsBot?
                .takeScreenShot(activity, "DetailsReached")
                .checkRemoveFromFavoritesExists()
                .checkIfContainsLabelWithText("Bulbasaur")
            
        }
        
    }
    
    func testAddToFavoritesWithoutBots() {
        
        mockPokemonList()
        mockBulbassaur()
        
        group("Given the Home View is loaded") { (activity) in
            
            // check if the homeview is loaded
            let rootView = app.descendants(matching: .any).matching(identifier: "home.views.root").firstMatch
            let rootViewExists = rootView.waitForExistence(timeout: 2.0)
            XCTAssertTrue(rootViewExists, "Home rootView not loaded in time")
            
            takeScreenshot(activity: activity, "Home Loaded")
            
            // Find the TableView
            let tableView = app.tables.firstMatch
            XCTAssertTrue(tableView.exists, "TableView dos not exist")
            
            // Tap First cell the given text: "#1: Bulbasaur"
            let cellText = "#1: Bulbasaur"
            let cellWithText = tableView.cells.containing(.staticText, identifier: cellText).firstMatch
            XCTAssert(cellWithText.exists, "Cell containing \(cellText) does not exist")
            cellWithText.tap()
            
        }
        
        group("Selected #1: Bulbasaur") { (activity) in
            
            // Check rootView
            let rootView = app.descendants(matching: .any).matching(identifier: "details.views.root").firstMatch
            let rootViewExists = rootView.waitForExistence(timeout: 2.0)
            XCTAssertTrue(rootViewExists, "Details rootView not loaded in time")
            
            takeScreenshot(activity: activity)
            
            // Find Add Favorites Button
            let addOrRemoveFavoriteButton = app.descendantElement(with: "details.buttons.addRemoveFavorite")
            let buttonExists = addOrRemoveFavoriteButton.waitForExistence(timeout: 1.0)
            XCTAssert(buttonExists, "AddOrRemoveFavorite button does not exist")
            let buttonLabel = addOrRemoveFavoriteButton.label
            XCTAssertEqual(buttonLabel, "Add to Favorites", "Invalid button state")
            
            // Tap AddOrRemoveFavorites Button
            addOrRemoveFavoriteButton.tap()
            
            // Wait to reach Home again...
            let homeRootView = app.descendantElement(with: "home.views.root")
            let homeRootViewExists = homeRootView.waitForExistence(timeout: 1.0)
            XCTAssert(homeRootViewExists, "Did not reach Home")
            
        }
        
        group("Check if Favorites contain Bulbassaur") { (activity) in
            
            // Find Favorites tab on Home and Tap it
            let tabText = "Favorites"
            let tabWithText = app.tabBars.buttons[tabText]
            XCTAssert(tabWithText.exists, "Tab containing \(tabText) does not exist")
            tabWithText.tap()
            
            takeScreenshot(activity: activity, "Reached Favorites")
            
            // Check if Favorites screen Contains "Bulbassaur" Text
            let collectionView = app.collectionViews.firstMatch
            XCTAssertTrue(collectionView.exists, "CollectionView dos not exist")
            
            let cellText = "Bulbassaur"
            let cellWithText = collectionView.cells.containing(.staticText, identifier: cellText).firstMatch
            XCTAssert(cellWithText.exists, "Cell containing \(cellText) does not exist")

            cellWithText.tap()
            
            // Verify Details screen
            let detailsRootView = app.descendants(matching: .any).matching(identifier: "details.views.root").firstMatch
            let detailsRootViewExists = detailsRootView.waitForExistence(timeout: 2.0)
            XCTAssertTrue(detailsRootViewExists, "Details rootView not loaded in time")
            
            takeScreenshot(activity: activity, "DetailsReached")
            
            // Verify remove from favorites button
            let removeFromFavoritesButton = app.descendantElement(with: "details.buttons.addRemoveFavorite")
            let buttonExists = removeFromFavoritesButton.waitForExistence(timeout: 1.0)
            XCTAssert(buttonExists, "AddOrRemoveFavorite button does not exist")
            let buttonLabel = removeFromFavoritesButton.label
            XCTAssertEqual(buttonLabel, "Remove from Favorites", "Invalid button state")
            
            let labelText = "Bulbasaur"
            let labelWithText = app.staticTexts[labelText]
            let labelWithTextExists = labelWithText.waitForExistence(timeout: 1.0)
            XCTAssertTrue(labelWithTextExists, "Label containing \(labelText) does not exists")
            
        }
        
        
    }
    
}
