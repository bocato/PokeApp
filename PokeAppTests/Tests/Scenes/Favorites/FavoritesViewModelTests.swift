//
//  FavoritesViewModelTests.swift
//  PokeAppTests
//
//  Created by Eduardo Bocato on 04/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class FavoritesViewModelTests: XCTestCase {

    // MARK: - Properties
    var sut: FavoritesViewModel!
    var actionsDelegateStub: FavoritesViewControllerActionsDelegateStub!
    var favoritesManagerStub: FavoritesManagerStub!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        actionsDelegateStub = FavoritesViewControllerActionsDelegateStub()
        favoritesManagerStub = FavoritesManagerStub()
        sut = FavoritesViewModel(actionsDelegate: actionsDelegateStub, favoritesManager: favoritesManagerStub)
    }
    
    // MARK: - Tests
    func testInit() {
        XCTAssertNotNil(sut, "initalization failed")
        XCTAssertNotNil(sut.actionsDelegate, "ActionsDelegate was not set")
        XCTAssertNotNil(sut.favoritesManager)
    }
    
    func testLoadFavoritesEmpty() {
        // Given
        let expectedStates: [CommonViewModelState] = [.empty]
        
        let viewStateCollector = RxCollector<CommonViewModelState>()
            .collect(from: sut.viewState.asObservable())
        let favoriteCollectionViewCellModelsCollector = RxCollector<[FavoriteCollectionViewCellModel]>()
            .collect(from: sut.favoritesCellModels.asObservable())
        
        // When
        sut.loadFavorites()

        // Then
        XCTAssertEqual(viewStateCollector.items, expectedStates, "State stream is invalid")
        XCTAssertNotNil(favoriteCollectionViewCellModelsCollector.items.first)
        XCTAssertTrue(favoriteCollectionViewCellModelsCollector.items.first!.isEmpty, "Items is not empty")
    }
    
    func testLoadFavoritesLoaded() {
        // Given
        let expectedStates: [CommonViewModelState] = [.loaded]
        let pikachu = Pokemon(id: 90909123, name: "pikachu", baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        
        let viewStateCollector = RxCollector<CommonViewModelState>()
            .collect(from: sut.viewState.asObservable())
        let favoriteCollectionViewCellModelsCollector = RxCollector<[FavoriteCollectionViewCellModel]>()
            .collect(from: sut.favoritesCellModels.asObservable())
        
        // When
        favoritesManagerStub.add(pokemon: pikachu)
        sut.loadFavorites()
        
        // Then
        XCTAssertEqual(viewStateCollector.items, expectedStates, "State stream is invalid")
        XCTAssertNotNil(favoriteCollectionViewCellModelsCollector.items.first)
        XCTAssertTrue(favoriteCollectionViewCellModelsCollector.items.first!.count == 1, "Items is not empty")
    }
    
    func testShowItemDetailsForSelectedFavoriteCellModel() {
        
    }
    

}

// MARK: - Helpers
class FavoritesViewControllerActionsDelegateStub: FavoritesViewControllerActionsDelegate {
    
    // MARK: Control Variables
    var showItemDetailsForPokemonWithIdWasCalled = false
    var idToRequestDetails: Int?
    
    // MARK: -
    func showItemDetailsForPokemonWith(id: Int) {
        showItemDetailsForPokemonWithIdWasCalled = true
        idToRequestDetails = id
    }
    
}

class FavoritesManagerStub: FavoritesManager {
    
    // MARK: - Properties
    internal(set) var favorites = [Pokemon]()
    
    // MARK: - Helpers
    func add(pokemon: Pokemon) {
        guard let id = pokemon.id, favorites.filter( { $0.id == id } ).first == nil else {
            return
        }
        favorites.append(pokemon)
        favorites.sort(by: { $0.id! < $1.id! })
    }
    
    func remove(pokemon: Pokemon) {
        guard let id = pokemon.id, let index = favorites.index(where: { $0.id ==  id }) else {
            return
        }
        favorites.remove(at: index)
    }
    
    func isFavorite(pokemon: Pokemon) -> Bool {
        guard let id = pokemon.id, let _ = favorites.filter( { $0.id == id } ).first else {
            return false
        }
        return true
    }
    
}
