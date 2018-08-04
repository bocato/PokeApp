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
import RxTest
import RxBlocking

class HomeViewModelTests: XCTestCase {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var testScheduler: TestScheduler!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests
    func testInit() {
        // Given
        let actionsDelegateStub = HomeViewControllerActionsDelegateStub()
        let mockURL = URL(string: "http://someurl.com")!
        let mockedSession = MockedURLSession(jsonDict: [:])!
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
        let mockedSession = MockedURLSession(jsonDict: [:])!
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
    
    func testEmptyState() {
        // Given
        let actionsDelegateStub = HomeViewControllerActionsDelegateStub()
        let mockURL = URL(string: "http://someurl.com")!
        let mockedSession = MockedURLSession(data: nil, response: nil, error: nil)
        let mockedNetworkDispatcher = NetworkDispatcher(url: mockURL, session: mockedSession)
        let mockedPokemonServices = PokemonService(dispatcher: mockedNetworkDispatcher)
        
        // When
        let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: mockedPokemonServices)
        let viewStateResults = testScheduler.createObserver(HomeViewModel.State.self)
        
        testScheduler.scheduleAt(0) {
            sut.viewState.subscribe(viewStateResults.asObserver()).disposed(by: self.disposeBag)
            let _ = sut.loadPokemons().subscribe().disposed(by: self.disposeBag)
        }
        
        testScheduler.start()
        
        // Then
        let viewStateExpectedResults: [HomeViewModel.State] = [.loading(true), .loading(true), .loading(false), .empty]
        var colectedViewStates = [HomeViewModel.State]()
        for event in viewStateResults.events {
            guard let element = event.value.element else { return }
            colectedViewStates.append(element)
        }
        XCTAssertEqual(viewStateExpectedResults, colectedViewStates)
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
