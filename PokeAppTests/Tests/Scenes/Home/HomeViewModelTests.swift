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
    var actionsDelegateStub: HomeViewControllerActionsDelegateStub!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        actionsDelegateStub = HomeViewControllerActionsDelegateStub()
    }
    
    // MARK: - Tests
    func testInit() {
        // Given
        var sut: HomeViewModel
        // When
        sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: PokemonServiceStub())
        // Then
        XCTAssertNotNil(sut, "invalid viewModel instance")
        XCTAssertNotNil(sut.actionsDelegate, "ActionsDelegate was not set")
    }
    
    func testInitialState() {
        // Given
        let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: PokemonServiceStub())
        
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
        let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: pokemonService)
        
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
        let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: pokemonService)
        
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
    
//    func testLoadedStateWithOnePokemon() {
//        // Given
//        let jsonDictionary: [String: Any] =
//            ["count": 949,
//             "results": [
//                ["url": "https://pokeapi.co/api/v2/pokemon/1/",
//                "name" :"bulbasaur"]
//                ],
//             "next": "https://pokeapi.co/api/v2/pokemon/?limit=1&offset=1"]
//        let data = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
//        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=150")!
//        let request = URLRequest(url: url)
//        URLSession.mockNext(request: request, body: data, delay: 1)
//
//        // When
//        let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services:  PokemonService())
//        let viewStateCollector = RxCollector<CommonViewModelState>()
//            .collect(from: sut.viewState.asObservable())
//        let pokemonCellModelsCollector = RxCollector<[PokemonTableViewCellModel]>()
//            .collect(from: sut.pokemonCellModels.asObservable())
//
////        let loadPokemonsExpectation = expectation(description: "loadPokemonsObservable() fetched a result")
////        _ = sut.loadPokemonsObservable().do(onCompleted: {
////            loadPokemonsExpectation.fulfill()
////        }).fireSingleEvent(disposedBy: disposeBag)
//
////        waitForExpectations(timeout: 1, handler: nil)
//
//        // Then
//        XCTAssertTrue(viewStateCollector.items.contains(where: { $0 == .loaded }), ".loaded State not reached")
//        XCTAssertTrue(pokemonCellModelsCollector.items.count == 2, "pokemonCellModels.count is not 2")
//        XCTAssertTrue(pokemonCellModelsCollector.items.last!.count == 1, "pokemonCellModelsCollector.items[1].count != 1")
//        XCTAssertTrue(pokemonCellModelsCollector.items.last!.first!.pokemonListItem.name! == "bulbasaur", "we don't have a bulbassaur in the first result")
//    }
    /////////// OLD
    
    func testShowItemDetailsForSelectedCellModelCalledWithValidPokemonCellModel() {
        // Given
        let pokemonService = PokemonServiceStub(mockType: .bulbassaurData)
        guard let listResponse = try? JSONDecoder().decode(PokemonListResponse.self, from: MockDataHelper.getData(forResource: .pokemonList)), let bulbassaurListResult = listResponse.results?.first else {
            XCTFail("Could not prepare test case.")
            return
        }
        let cellModel = PokemonTableViewCellModel(listItem: bulbassaurListResult)
        let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: pokemonService)

        // When
        sut.showItemDetailsForSelectedCellModel(cellModel)

        // Then
        XCTAssertTrue(actionsDelegateStub.showItemDetailsForPokemonWithIdWasCalled, "showItemDetailsForSelectedCellModel() was not called")
        XCTAssertNotNil(actionsDelegateStub.pokemonIdToShowDetails, "Invalid pokemon id")
        XCTAssertEqual(actionsDelegateStub.pokemonIdToShowDetails!, bulbassaurListResult.id!, "Invalid pokemon id")
    }

    func testShowItemDetailsForSelectedCellModelCalledWithInvalidPokemonCellModel() {
        // Given
        let pokemonService = PokemonServiceStub()
        let pokemonListItem = PokemonListResult(url: "url", name: "")
        let cellModel = PokemonTableViewCellModel(listItem: pokemonListItem)
        let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: pokemonService)
        
        // When
        sut.showItemDetailsForSelectedCellModel(cellModel)

        // Then
        XCTAssertFalse(actionsDelegateStub.showItemDetailsForPokemonWithIdWasCalled, "showItemDetailsForSelectedCellModel() was called")
        XCTAssertNil(actionsDelegateStub.pokemonIdToShowDetails, "The pokemon id should be nil")
    }
    
}

// MARK: - Stubs
class HomeViewControllerActionsDelegateStub: HomeViewControllerActionsDelegate {
    
    var showItemDetailsForPokemonWithIdWasCalled = false
    var pokemonIdToShowDetails: Int?
    
    func showItemDetailsForPokemonWith(id: Int) {
        showItemDetailsForPokemonWithIdWasCalled = true
        pokemonIdToShowDetails = id
    }
    
}
