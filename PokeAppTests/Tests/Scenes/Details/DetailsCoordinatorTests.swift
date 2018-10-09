//
//  DetailsCoordinatorTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 06/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class DetailsCoordinatorTests: XCTestCase {

    // MARK: - Properties
    var coordinatorDelegateSpy: CoordinatorDelegateSpy!
    var sut: DetailsCoordinatorSpy!
    var imageDownloader: ImageDownloaderProtocol!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        coordinatorDelegateSpy = CoordinatorDelegateSpy()
        sut = DetailsCoordinatorSpy(router: SimpleRouter())
        imageDownloader = KingfisherImageDownloader() // TODO: Change this to the mock version
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Tests
    func testAddFavorite() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        
        let favoritesManagerStub = FavoritesManagerStub()
        let pokemonService = PokemonServiceStub()
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManagerStub, imageDownloader: imageDownloader)
        let pokemonDetailsViewModel = PokemonDetailsViewModel(pokemonData: bulbassaur, dataSources: dataSources, actionsDelegate: sut)

        // When
        pokemonDetailsViewModel.actOnFavoritesButtonTouch()

        // Then
        XCTAssertTrue(sut.didAddFavoriteWasCalled)
        XCTAssertNotNil(sut.lastOutputSentToParent)
        XCTAssertEqual(sut.lastOutputSentToParent!, .didAddPokemon, "Invalid output.")
        XCTAssertNotNil(sut.lastAddedPokemon)
    }
    
    func testRemoveFavorite() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        
        let favoritesManagerStub = FavoritesManagerStub()
        let pokemonService = PokemonServiceStub()
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManagerStub, imageDownloader: imageDownloader)
        let pokemonDetailsViewModel = PokemonDetailsViewModel(pokemonData: bulbassaur, dataSources: dataSources, actionsDelegate: sut)
        
        favoritesManagerStub.add(pokemon: bulbassaur)
        
        // When
        pokemonDetailsViewModel.actOnFavoritesButtonTouch()
        
        // Then
        XCTAssertTrue(sut.didRemoveFavoriteWasCalled)
        XCTAssertNotNil(sut.lastOutputSentToParent)
        XCTAssertEqual(sut.lastOutputSentToParent!, .didRemovePokemon, "Invalid output.")
        XCTAssertNotNil(sut.lastRemovedPokemon)
        XCTAssertEqual(sut.lastRemovedPokemon!.id!, bulbassaur.id!)
    }
    
}

// MARK: - Helpers
class DetailsCoordinatorSpy: DetailsCoordinator {
    
    // MARK: - Control Variables
    var lastOutputSentToParent: DetailsCoordinator.Output?
    var didAddFavoriteWasCalled = false
    var lastAddedPokemon: Pokemon?
    var didRemoveFavoriteWasCalled = false
    var lastRemovedPokemon: Pokemon?
    
    // MARK: - PokemonDetailsViewControllerActionsDelegate Methods
    override func didAddFavorite(_ pokemon: Pokemon) {
        didAddFavoriteWasCalled = true
        lastAddedPokemon = pokemon
        lastOutputSentToParent = .didAddPokemon
        super.didAddFavorite(pokemon)
    }
    
   override func didRemoveFavorite(_ pokemon: Pokemon) {
        didRemoveFavoriteWasCalled = true
        lastRemovedPokemon = pokemon
        lastOutputSentToParent = .didRemovePokemon
        super.didRemoveFavorite(pokemon)
    }
    
}
