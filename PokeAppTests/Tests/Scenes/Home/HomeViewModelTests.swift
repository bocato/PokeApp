//
//  HomeViewModelTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 31/07/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
import RxSwift
@testable import PokeApp

class HomeViewModelTests: XCTestCase {
    
    // MARK: - Properties

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }
    
    // MARK: - Tests
    func testInit() {
        // Given
        let actionsDelegateStub = HomeViewControllerActionsDelegateStub()
        let mockURL = URL(string: "http://someurl.com")!
        let mockedSession = MockURLSession(jsonDict: [:])!
        let mockedNetworkDispatcher = NetworkDispatcher(url: mockURL, session: mockedSession)
        let mockedPokemonServices = PokemonService(dispatcher: mockedNetworkDispatcher)
        // When
        let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: mockedPokemonServices)
        // Then
        XCTAssertNotNil(sut, "invalid viewModel instance")
        XCTAssertNotNil(sut.actionsDelegate, "ActionsDelegate was not set")
    }
    
    func testInitialState() {
        // Given
        let actionsDelegateStub = HomeViewControllerActionsDelegateStub()
        let mockURL = URL(string: "http://someurl.com")!
        let mockedSession = MockURLSession(jsonDict: [:])!
        let mockedNetworkDispatcher = NetworkDispatcher(url: mockURL, session: mockedSession)
        let mockedPokemonServices = PokemonService(dispatcher: mockedNetworkDispatcher)
        
        // When
        let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: mockedPokemonServices)
        
        let stateCollector = RxCollector<HomeViewModel.State>()
                                .collect(from: sut.viewState.asObservable())
        let pokemonCellModelsCollector = RxCollector<[PokemonTableViewCellModel]>()
                                            .collect(from: sut.pokemonCellModels.asObservable())
        
        // Then
        let firstCollectedState = stateCollector.items.first!
        let expectedState: HomeViewModel.State = .loading(true)
        XCTAssertEqual(firstCollectedState, expectedState, "First viewState is != loading(true)")
        
        let collectedPokemonCellModels = pokemonCellModelsCollector.items.first!
        XCTAssertTrue(collectedPokemonCellModels.isEmpty, "First pokemonCellModels is not []")
    }
    
    func testEmptyState() { // this is wrong
        // Given
        let actionsDelegateStub = HomeViewControllerActionsDelegateStub()
        let mockURL = URL(string: "http://someurl.com")!
        let mockedSession = MockURLSession(data: nil, response: nil, error: nil)
        let mockedNetworkDispatcher = NetworkDispatcher(url: mockURL, session: mockedSession)
        let mockedPokemonServices = PokemonService(dispatcher: mockedNetworkDispatcher)
        
        // When
        let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: mockedPokemonServices)
        
        let stateCollector = RxCollector<HomeViewModel.State>()
            .collect(from: sut.viewState.asObservable())
        let pokemonCellModelsCollector = RxCollector<[PokemonTableViewCellModel]>()
            .collect(from: sut.pokemonCellModels.asObservable())

        sut.loadPokemons()

        // Then
        let collectedState = stateCollector.items.last!
        let expectedState: HomeViewModel.State = .loading(true)
        XCTAssertEqual(collectedState, expectedState, "viewState is != loading(true)")

        let collectedPokemonCellModels = pokemonCellModelsCollector.items.last!
        XCTAssertTrue(collectedPokemonCellModels.isEmpty, "First pokemonCellModels is not []")
    }
    
}

extension HomeViewModel.State: Equatable {
    
    public static func ==(lhs: HomeViewModel.State, rhs: HomeViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case let (.loading(l), .loading(r)): return l == r
        case (.empty, .empty): return true
        case let (.error(l), .error(r)): return l.debugDescription == r.debugDescription // check this, conform objects to equatable
        default: return false
        }
    }
    
}

class HomeViewControllerActionsDelegateStub: HomeViewControllerActionsDelegate {
    
    var showItemDetailsForPokemonWithIdWasCalled = false
    var pokemonIdToShowDetails: Int?
    
    func showItemDetailsForPokemonWith(id: Int) {
        showItemDetailsForPokemonWithIdWasCalled = true
        pokemonIdToShowDetails = id
    }
    
}
