//
//  HomeViewModelTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 31/07/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp
import RxSwift

class HomeViewModelTests: XCTestCase {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var homeCoordinatorSpy: HomeCoordinatorSpy!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        homeCoordinatorSpy = HomeCoordinatorSpy(router: Router(), favoritesManager: FavoritesManagerStub(), modulesFactory: HomeCoordinatorModulesFactory())
    }
    
    // MARK: - Tests
    func testInit() {
        // Given
        var sut: HomeViewModel
        // When
        sut = HomeViewModel(actionsDelegate: homeCoordinatorSpy, services: PokemonServiceStub())
        // Then
        XCTAssertNotNil(sut, "invalid viewModel instance")
        XCTAssertNotNil(sut.actionsDelegate, "ActionsDelegate was not set")
    }
    
    func testInitialState() {
        // Given
        let sut = HomeViewModel(actionsDelegate: homeCoordinatorSpy, services: PokemonServiceStub())
        
        // When
        let pokemonCellModelsCollector = RxCollector<[PokemonTableViewCellModel]>()
            .collect(from: sut.pokemonCellModels.asObservable())
        
        // Then
        let collectedPokemonCellModels = pokemonCellModelsCollector.items.first!
        XCTAssertTrue(collectedPokemonCellModels.isEmpty, "First pokemonCellModels is not []")
    }
    
    func testEmptyState() {
        // Given
        let pokemonService = PokemonServiceStub(mockType: .empty)
        let sut = HomeViewModel(actionsDelegate: homeCoordinatorSpy, services: pokemonService)
        
        let viewStateCollector = RxCollector<CommonViewModelState>()
            .collect(from: sut.viewState.asObservable())
        let pokemonCellModelsCollector = RxCollector<[PokemonTableViewCellModel]>()
            .collect(from: sut.pokemonCellModels.asObservable())
        
        // When
        sut.loadPokemons()
        
        // Then
        let viewStateExpectedResults: [CommonViewModelState] = [.loading(true), .empty, .loading(false)]
        XCTAssertEqual(viewStateExpectedResults, viewStateCollector.items, "Invalid events for .empty state.")
        XCTAssertTrue(pokemonCellModelsCollector.items.first!.isEmpty, "pokemonCellModels is not empty")
    }
    
    func testErrorState() {
        // Given
        let mockError = NSError.buildMockError(code: 404, description: "LoadPokemons error.")
        let pokemonService = PokemonServiceStub(mockType: .error(mockError))
        let sut = HomeViewModel(actionsDelegate: homeCoordinatorSpy, services: pokemonService)
        
        let viewStateCollector = RxCollector<CommonViewModelState>()
            .collect(from: sut.viewState.asObservable())
        let pokemonCellModelsCollector = RxCollector<[PokemonTableViewCellModel]>()
            .collect(from: sut.pokemonCellModels.asObservable())
        
        // When
        sut.loadPokemons()
        
        // Then
        var isLastStateAnError = false
        switch viewStateCollector.items.last! {
            case .error(_): isLastStateAnError = true
                break
            default: XCTFail("The last viewState is not an error!")
        }
        XCTAssertTrue(isLastStateAnError, "The last viewState is not an error!")
        XCTAssertTrue(pokemonCellModelsCollector.items.first!.isEmpty, "pokemonCellModels is not empty")
    }
    
    func testLoadedState() {
        // Given
        let pokemonService = PokemonServiceStub(mockType: .pokemonList)
        let sut = HomeViewModel(actionsDelegate: homeCoordinatorSpy, services: pokemonService)
        
        let viewStateCollector = RxCollector<CommonViewModelState>()
            .collect(from: sut.viewState.asObservable())
        let pokemonCellModelsCollector = RxCollector<[PokemonTableViewCellModel]>()
            .collect(from: sut.pokemonCellModels.asObservable())
        
        // When
        sut.loadPokemons()
        
        // Then
        XCTAssertTrue(viewStateCollector.items.contains(where: { $0 == .loaded }), ".loaded State not reached")
        XCTAssertTrue(pokemonCellModelsCollector.items.count == 2, "pokemonCellModels.count is not 2")
        XCTAssertTrue(pokemonCellModelsCollector.items.last!.count == 151, "pokemonCellModelsCollector.items[1].count != 1")
    }
    
    func testShowItemDetailsForSelectedCellModelCalledWithValidPokemonCellModel() {
        // Given
        let pokemonService = PokemonServiceStub(mockType: .bulbassaurData)
        guard let listResponse = try? JSONDecoder().decode(PokemonListResponse.self, from: MockDataHelper.getData(forResource: .pokemonList)), let bulbassaurListResult = listResponse.results?.first else {
            XCTFail("Could not prepare test case.")
            return
        }
        let cellModel = PokemonTableViewCellModel(listItem: bulbassaurListResult)
        let sut = HomeViewModel(actionsDelegate: homeCoordinatorSpy, services: pokemonService)

        // When
        sut.showItemDetailsForSelectedCellModel(cellModel)

        // Then
        XCTAssertTrue(homeCoordinatorSpy.showItemDetailsForPokemonWithIdWasCalled, "showItemDetailsForSelectedCellModel() was not called")
        XCTAssertNotNil(homeCoordinatorSpy.idForLastPokemonDetailsRequest, "Invalid pokemon id")
        XCTAssertEqual(homeCoordinatorSpy.idForLastPokemonDetailsRequest!, bulbassaurListResult.id!, "Invalid pokemon id")
    }

    func testShowItemDetailsForSelectedCellModelCalledWithInvalidPokemonCellModel() {
        // Given
        let pokemonService = PokemonServiceStub()
        let pokemonListItem = PokemonListResult(url: "url", name: "")
        let cellModel = PokemonTableViewCellModel(listItem: pokemonListItem)
        let sut = HomeViewModel(actionsDelegate: homeCoordinatorSpy, services: pokemonService)
        
        // When
        sut.showItemDetailsForSelectedCellModel(cellModel)

        // Then
        XCTAssertFalse(homeCoordinatorSpy.showItemDetailsForPokemonWithIdWasCalled, "showItemDetailsForSelectedCellModel() was called")
        XCTAssertNil(homeCoordinatorSpy.idForLastPokemonDetailsRequest, "The pokemon id should be nil")
    }
    
}
