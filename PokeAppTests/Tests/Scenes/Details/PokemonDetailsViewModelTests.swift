//
//  PokemonDetailsViewModelTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 06/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class PokemonDetailsViewModelTests: XCTestCase {

    // MARK: - Properties
    var sut: PokemonDetailsViewModel!
    var actionsDelegate: PokemonDetailsViewControllerActionsDelegateStub!
    
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        setupTestEnvironment()
    }
    
    override func tearDown() {
        super.tearDown()
        URLSession.removeAllMocks()
    }
    
    func setupTestEnvironment() {
        let pokemonId = 1
        let pokemonService = PokemonService()
        let favoritesManager = FavoritesManagerStub()
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManager)
        actionsDelegate = PokemonDetailsViewControllerActionsDelegateStub()
        sut = PokemonDetailsViewModel(pokemonId: pokemonId, dataSources: dataSources, actionsDelegate: actionsDelegate)
        mockServiceResponse()
    }
    
    func mockServiceResponse() {
        let data = MockDataHelper.getData(forResource: .bulbassaur)
        do {
            try URLSession.mockEvery(expression: "v2/pokemon/1", body: data)
        } catch _ {
            XCTFail("Could not mock data.")
        }
    }

    // MARK: -
    func testActOnFavoritesButtonTouch_addingFavorite() {
        
    }
    
    

}
class PokemonDetailsViewControllerActionsDelegateStub: PokemonDetailsViewControllerActionsDelegate {
    
    // MARK: - Control Variables
    var didAddFavoriteWasCalled = false
    var didRemoveFavoriteWasCalled = false
    
    // MARK: - PokemonDetailsViewControllerActionsDelegate
    func didAddFavorite() {
        didAddFavoriteWasCalled = true
    }
    
    func didRemoveFavorite() {
        didRemoveFavoriteWasCalled = true
    }
    
}
