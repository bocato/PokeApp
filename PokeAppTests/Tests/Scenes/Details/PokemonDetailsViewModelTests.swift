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

class PokemonDetailsViewModelTests: XCTestCase {

    // MARK: - Properties
    var detailsCoordinatorSpy: DetailsCoordinatorSpy!
    var favoritesManagerStub: FavoritesManagerStub!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        setupTestEnvironment()
    }
    
    func setupTestEnvironment() {
        favoritesManagerStub = FavoritesManagerStub()
        detailsCoordinatorSpy = DetailsCoordinatorSpy(router: Router())
    }

    // MARK: - Tests
    func testActOnFavoritesButtonTouch_AddingFavorite() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        
        let pokemonService = PokemonServiceStub()
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManagerStub)
        let sut = PokemonDetailsViewModel(pokemonData: bulbassaur, dataSources: dataSources, actionsDelegate: detailsCoordinatorSpy)
        
        // When
        sut.actOnFavoritesButtonTouch()
        
        // Then
        let bulbassaurSearch = favoritesManagerStub.favorites.filter( { $0.name == "bulbassaur" })
        XCTAssertNotNil(bulbassaurSearch)
    }
    
    func testActOnFavoritesButtonTouch_RemovingFavorite() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        favoritesManagerStub.add(pokemon: bulbassaur)

        let pokemonService = PokemonService()
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManagerStub)
        let sut = PokemonDetailsViewModel(pokemonData: bulbassaur, dataSources: dataSources, actionsDelegate: detailsCoordinatorSpy)

        // When
        sut.actOnFavoritesButtonTouch()
        
        // Then
        XCTAssertTrue(detailsCoordinatorSpy.didRemoveFavoriteWasCalled)
        let bulbassaurSearch = self.favoritesManagerStub.favorites.filter( { $0.name == "bulbassaur" })
        XCTAssertTrue(bulbassaurSearch.isEmpty)
    }
    
    func testActOnFavoritesButtonTouchWithNilData() {
        // Given
        let pokemonService = PokemonServiceStub(mockType: .empty)
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManagerStub)
        let sut = PokemonDetailsViewModel(pokemonId: 1, dataSources: dataSources, actionsDelegate: detailsCoordinatorSpy)
        
        // When
        sut.actOnFavoritesButtonTouch()
        
        // Then
        XCTAssertFalse(detailsCoordinatorSpy.didRemoveFavoriteWasCalled)
        XCTAssertFalse(detailsCoordinatorSpy.didAddFavoriteWasCalled)
    }
    
    func testLoadPokemonData_unexpectedError() {
        // Given
        let pokemonService = PokemonServiceStub(mockType: .empty)
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManagerStub)
        let sut = PokemonDetailsViewModel(pokemonId: 1, dataSources: dataSources, actionsDelegate: detailsCoordinatorSpy)
        
        let viewStateCollector = RxCollector<CommonViewModelState>()
            .collect(from: sut.viewState.asObservable())
        let isLoadingPokemonDataCollector = RxCollector<Bool>()
            .collect(from: sut.isLoadingPokemonData.asObservable())
        
        // When
        sut.loadPokemonData()
        
        // Then
        guard let lastState = viewStateCollector.items.last, let isLoadingPokemonData = isLoadingPokemonDataCollector.items.last else {
            XCTFail("No states collected.")
            return
        }
        
        var isLastStateAnError = false
        switch lastState {
        case .error(_):
            isLastStateAnError = true
        default:
            isLastStateAnError = false
        }
        XCTAssertFalse(isLoadingPokemonData)
        XCTAssertTrue(isLastStateAnError)
    }
    
    func testLoadPokemonData_withBulbassaur() {
        // Given
        let pokemonService = PokemonServiceStub(mockType: .bulbassaurData)
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManagerStub)
        let sut = PokemonDetailsViewModel(pokemonId: 1, dataSources: dataSources, actionsDelegate: detailsCoordinatorSpy)
        
        // When
        sut.loadPokemonData()
        
        // Then
        XCTAssertNotNil(sut.pokemonData) // TODO: Test PokemonImage
    }
    
    func testLoadPokemonData_withServiceError() {
        // Given
        let mockError = NSError.buildMockError(code: 404, description: "LoadPokemonData error.")
        let pokemonService = PokemonServiceStub(mockType: .error(mockError))
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManagerStub)
        let sut = PokemonDetailsViewModel(pokemonId: 1, dataSources: dataSources, actionsDelegate: detailsCoordinatorSpy)
        
        let viewStateCollector = RxCollector<CommonViewModelState>()
            .collect(from: sut.viewState.asObserver())
        
        // When
        sut.loadPokemonData()
        
        // Then
        XCTAssertNil(sut.pokemonData) // TODO: Test PokemonImage
        var lastStateIsAnError = false
        if let lastState = viewStateCollector.items.last {
            switch lastState {
            case .error(_): lastStateIsAnError = true
            default: return
            }
            XCTAssertTrue(lastStateIsAnError)
        }
    }
    
}
