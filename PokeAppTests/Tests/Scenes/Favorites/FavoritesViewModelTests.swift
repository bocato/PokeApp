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
    var mockedFavoritesStub: FavoritesManagerStub!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        actionsDelegateStub = FavoritesViewControllerActionsDelegateStub()
        mockedFavoritesStub = FavoritesManagerStub()
        sut = FavoritesViewModel(actionsDelegate: actionsDelegateStub, favoritesManager: mockedFavoritesStub)
    }
    
    // MARK: - Tests
    func testInit() {
        XCTAssertNotNil(sut, "initalization failed")
        XCTAssertNotNil(sut.actionsDelegate, "ActionsDelegate was not set")
        XCTAssertNotNil(sut.favoritesManager)
    }
    
    func testLoadFavoritesEmpty() {
        // Given
        let expectedStates: [CommonViewModelState] = [.loading(true), .loading(false), .empty]
        
        // When
        let viewStateCollector = RxCollector<CommonViewModelState>()
                .collect(from: sut.viewState.asObservable())
        let favoriteCollectionViewCellModelsCollector = RxCollector<[FavoriteCollectionViewCellModel]>()
            .collect(from: sut.favoritesCellModels.asObservable())
        
        sut.loadFavorites()
        
        // Then
        XCTAssertEqual(viewStateCollector.items, expectedStates, "State stream is invalid")
        XCTAssertTrue(favoriteCollectionViewCellModelsCollector.items.isEmpty, "Items is not empty")
    }
    
    func testLoadFavoritesWithElements() {
        // Given
        // When
        // Then
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
