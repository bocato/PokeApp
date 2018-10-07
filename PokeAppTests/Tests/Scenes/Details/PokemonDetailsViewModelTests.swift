//
//  PokemonDetailsViewModelTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 06/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

class PokemonDetailsViewModelTests: XCTestCase {

    // MARK: - Properties
    var sut: PokemonDetailsViewModel!
    var pokemonServiceStub: PokemonServiceStub!
    var actionsDelegateSpy: PokemonDetailsViewControllerActionsDelegateSpy!
    var favoritesManagerStub: FavoritesManagerStub!
    var testScheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
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
        pokemonServiceStub = PokemonServiceStub()
        favoritesManagerStub = FavoritesManagerStub()
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonServiceStub, favoritesManager: favoritesManagerStub)
        actionsDelegateSpy = PokemonDetailsViewControllerActionsDelegateSpy(favoritesManagerStub: favoritesManagerStub)
        sut = PokemonDetailsViewModel(pokemonId: pokemonId, dataSources: dataSources, actionsDelegate: actionsDelegateSpy)
        testScheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    // MARK: - Tests
    func testActOnFavoritesButtonTouch_addingFavorite() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        actionsDelegateSpy.pokemonToAdd = bulbassaur
        
        let pokemonService = PokemonService()
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManagerStub)
        let sut = PokemonDetailsViewModel(pokemonData: bulbassaur, dataSources: dataSources, actionsDelegate: actionsDelegateSpy)
        
        // When
        sut.actOnFavoritesButtonTouch()
        
        // Then
        XCTAssertTrue(actionsDelegateSpy.didAddFavoriteWasCalled)
        XCTAssertTrue(actionsDelegateSpy.didAddPokemon)
        let bulbassaurSearch = favoritesManagerStub.favorites.filter( { $0.name == "bulbassaur" })
        XCTAssertNotNil(bulbassaurSearch)
    }
    
    func testActOnFavoritesButtonTouch_RemovingFavorite() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        actionsDelegateSpy.pokemonToRemove = bulbassaur
        favoritesManagerStub.add(pokemon: bulbassaur)

        let pokemonService = PokemonService()
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManagerStub)
        let sut = PokemonDetailsViewModel(pokemonData: bulbassaur, dataSources: dataSources, actionsDelegate: actionsDelegateSpy)

        // When
        sut.actOnFavoritesButtonTouch()
        
        // Then
        XCTAssertTrue(self.actionsDelegateSpy.didRemoveFavoriteWasCalled)
        XCTAssertTrue(self.actionsDelegateSpy.didRemovePokemon)
        let bulbassaurSearch = self.favoritesManagerStub.favorites.filter( { $0.name == "bulbassaur" })
        XCTAssertTrue(bulbassaurSearch.isEmpty)
    }
    
    func testActOnFavoritesButtonTouchWithNilData() {
        // Given
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonServiceStub, favoritesManager: favoritesManagerStub)
        let sut = PokemonDetailsViewModel(pokemonId: 1, dataSources: dataSources, actionsDelegate: actionsDelegateSpy)
        
        // When
        sut.actOnFavoritesButtonTouch()
        
        // Then
        XCTAssertFalse(self.actionsDelegateSpy.didRemoveFavoriteWasCalled)
        XCTAssertFalse(self.actionsDelegateSpy.didAddFavoriteWasCalled)
    }
    
    func testLoadPokemonData_unexpectedError() {
        // Given
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonServiceStub, favoritesManager: favoritesManagerStub)
        let sut = PokemonDetailsViewModel(pokemonId: 1, dataSources: dataSources, actionsDelegate: actionsDelegateSpy)
        
        let viewStateCollector = RxCollector<CommonViewModelState>().collect(from: sut.viewState.asObservable())
        
        // When
        sut.loadPokemonData()
        
        // Then
        let expectedViewStates: [CommonViewModelState] = [.loading(true)]
        
    }
    
}

// MARK: - Mocking
private extension PokemonDetailsViewModelTests {
    
    func mockWithBulbassaurData() {
        let data = MockDataHelper.getData(forResource: .bulbassaur)
        do {
            try URLSession.mockEvery(expression: "v2/pokemon/1", body: data)
        } catch _ {
            XCTFail("Could not mock data.")
        }
    }
    
}


class PokemonDetailsViewControllerActionsDelegateSpy: PokemonDetailsViewControllerActionsDelegate {
    
    // MARK: - Dependencies
    private var favoritesManagerStub: FavoritesManagerStub
    
    // MARK: - Control Variables
    var didAddFavoriteWasCalled = false
    var didRemoveFavoriteWasCalled = false
    var pokemonToAdd: Pokemon?
    var didAddPokemon = false
    var pokemonToRemove: Pokemon?
    var didRemovePokemon = false
    
    // MARK: - Initialization
    init(favoritesManagerStub: FavoritesManagerStub) {
        self.favoritesManagerStub = favoritesManagerStub
    }
    
    // MARK: - PokemonDetailsViewControllerActionsDelegate
    func didAddFavorite() {
        didAddFavoriteWasCalled = true
        guard let pokemonToAdd = pokemonToAdd else {
            didAddPokemon = false
            return
        }
        favoritesManagerStub.add(pokemon: pokemonToAdd)
        didAddPokemon = true
    }
    
    func didRemoveFavorite() {
        didRemoveFavoriteWasCalled = true
        guard let pokemonToRemove = pokemonToRemove else {
            didAddPokemon = false
            return
        }
        favoritesManagerStub.remove(pokemon: pokemonToRemove)
        didRemovePokemon = true
    }
    
}
