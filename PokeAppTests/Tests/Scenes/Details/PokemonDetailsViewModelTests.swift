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

class PokemonDetailsViewModelTests: XCTestCase {

    // MARK: - Properties
    var sut: PokemonDetailsViewModel!
    var actionsDelegateSpy: PokemonDetailsViewControllerActionsDelegateSpy!
    var favoritesManagerStub: FavoritesManagerStub!
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
        disposeBag = DisposeBag()
        let pokemonId = 1
        let pokemonService = PokemonService()
        favoritesManagerStub = FavoritesManagerStub()
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManagerStub)
        actionsDelegateSpy = PokemonDetailsViewControllerActionsDelegateSpy(favoritesManagerStub: favoritesManagerStub)
        sut = PokemonDetailsViewModel(pokemonId: pokemonId, dataSources: dataSources, actionsDelegate: actionsDelegateSpy)
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

    // MARK: - Tests
//    func testActOnFavoritesButtonTouch_addingFavorite() {
//        // Given
//        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
//        actionsDelegateSpy.pokemonToAdd = bulbassaur
//
//        // When
//        let pokemonDataExpectation = expectation(description: "Did load pokemon data.")
//        sut.isLoadingPokemonData.asObservable().subscribe(onNext: { (isLoading) in
//            if isLoading == false {
//                pokemonDataExpectation.fulfill()
//            }
//        }).disposed(by: disposeBag)
//
//        sut.loadPokemonData()
//
//        wait(for: [pokemonDataExpectation], timeout: 1)
//
//        sut.actOnFavoritesButtonTouch()
//
//        // Then
//        XCTAssertTrue(actionsDelegateSpy.didAddFavoriteWasCalled)
//        XCTAssertTrue(actionsDelegateSpy.didAddPokemon)
//        let bulbassaurSearch = favoritesManagerStub.favorites.filter( { $0.name == "bulbassaur" })
//        XCTAssertNotNil(bulbassaurSearch)
//    }
//
//    func testActOnFavoritesButtonTouch_RemovingFavorite() {
//        // Given
//        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
//        actionsDelegateSpy.pokemonToRemove = bulbassaur
//        favoritesManagerStub.add(pokemon: bulbassaur)
//
//        // When
//        let pokemonDataExpectation = expectation(description: "Did load pokemon data.")
//        sut.isLoadingPokemonData.asObservable().subscribe(onNext: { (isLoading) in
//            if isLoading == false {
//                pokemonDataExpectation.fulfill()
//            }
//        }).disposed(by: disposeBag)
//
//        sut.loadPokemonData()
//
//        wait(for: [pokemonDataExpectation], timeout: 1)
//
//        sut.actOnFavoritesButtonTouch()
//
//        // Then
//        XCTAssertTrue(actionsDelegateSpy.didRemoveFavoriteWasCalled)
//        XCTAssertTrue(actionsDelegateSpy.didRemovePokemon)
//        let bulbassaurSearch = favoritesManagerStub.favorites.filter( { $0.name == "bulbassaur" })
//        XCTAssertNil(bulbassaurSearch)
//    }
    
    

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
