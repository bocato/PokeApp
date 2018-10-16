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
    func testAddToFavorites() {
        
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

}
