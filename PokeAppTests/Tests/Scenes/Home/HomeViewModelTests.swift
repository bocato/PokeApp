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
//import NURLSessionMock

class HomeViewModelTests: XCTestCase {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var actionsDelegateStub: HomeViewControllerActionsDelegateStub!
    var testScheduler: TestScheduler! // TODO: Delete this
    let mockURL = URL(string: "http://someurl.com")! // TODO: Delete this
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        actionsDelegateStub = HomeViewControllerActionsDelegateStub()
    }
    
    override func tearDown() {
        super.tearDown()
        URLSession.removeAllMocks()
    }
    
    // MARK: - Tests
    func testInit() {
        // Given
        var sut: HomeViewModel
        // When
        sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: PokemonService())
        // Then
        XCTAssertNotNil(sut, "invalid viewModel instance")
        XCTAssertNotNil(sut.actionsDelegate, "ActionsDelegate was not set")
    }
    
    func testInitialState() {
        // Given
        let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: PokemonService())
        
        // When
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
    
    func testEmptyStateUsingRxCollectorA() { // USE THIS...
        // Given
        let body1 = "{}".data(using: String.Encoding.utf8)!
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=150")!
        let request = URLRequest(url: url)
        URLSession.mockNext(request: request, body: body1, delay: 1)
        
        // When
        let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services:  PokemonService())
        let viewStateCollector = RxCollector<HomeViewModel.State>()
            .collect(from: sut.viewState.asObservable())
        let pokemonCellModelsCollector = RxCollector<[PokemonTableViewCellModel]>()
            .collect(from: sut.pokemonCellModels.asObservable())
        
        let loadPokemonsExpectation = expectation(description: "loadPokemons() fetched a result")
        sut.loadPokemons().subscribe(onCompleted: {
            loadPokemonsExpectation.fulfill()
        }).disposed(by: self.disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        let viewStateExpectedResults: [HomeViewModel.State] = [.loading(true), .loading(true), .empty, .loading(false)]
        XCTAssertEqual(viewStateExpectedResults, viewStateCollector.items, "Invalid events for .empty state.")
        XCTAssertTrue(pokemonCellModelsCollector.items.first!.isEmpty, "pokemonCellModels is not empty")
    }
    
    func testErrorState() { // TODO: Test error with URLSession.mockNext
        // Given
        let mockedResponse = HTTPURLResponse(url: mockURL, statusCode: 404, httpVersion: "HTTP/1.1", headerFields: nil)
        let mockedSession = MockedURLSession(jsonDict: [:], response: mockedResponse, error: nil)!
        let mockedNetworkDispatcher = NetworkDispatcher(url: mockURL, session: mockedSession)
        let mockedPokemonServices = PokemonService(dispatcher: mockedNetworkDispatcher)
        
        // When
        let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: mockedPokemonServices)
        let viewStateCollector = RxCollector<HomeViewModel.State>()
            .collect(from: sut.viewState.asObservable())
        let pokemonCellModelsCollector = RxCollector<[PokemonTableViewCellModel]>()
            .collect(from: sut.pokemonCellModels.asObservable())
        
        let loadPokemonsOnErrorExpectation = expectation(description: "loadPokemons() reached OnError")
        sut.loadPokemons().subscribe(onError: { (_) in
            loadPokemonsOnErrorExpectation.fulfill()
        }).disposed(by: self.disposeBag)
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        switch viewStateCollector.items.last! {
        case .error(let serializedError): XCTAssertNotNil(serializedError, "The error is nil!")
            break
        default: XCTFail("The last viewState is not an error!")
        }
        XCTAssertTrue(pokemonCellModelsCollector.items.first!.isEmpty, "pokemonCellModels is not empty")
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

//func testEmptyStateUsingRxCollectorAndMockedURLSession() { // Keep here for future reference...
//    // Given
//    let mockedResponse = HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
//    let mockedSession = MockedURLSession(data: nil, response: mockedResponse, error: nil)
//    let mockedNetworkDispatcher = NetworkDispatcher(url: mockURL, session: mockedSession)
//    let mockedPokemonServices = PokemonService(dispatcher: mockedNetworkDispatcher)
//
//    // When
//    let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: mockedPokemonServices)
//    let viewStateCollector = RxCollector<HomeViewModel.State>()
//        .collect(from: sut.viewState.asObservable())
//    let pokemonCellModelsCollector = RxCollector<[PokemonTableViewCellModel]>()
//        .collect(from: sut.pokemonCellModels.asObservable())
//
//    let loadPokemonsExpectation = expectation(description: "loadPokemons() fetched a result")
//    sut.loadPokemons().subscribe(onCompleted: {
//        loadPokemonsExpectation.fulfill()
//    }).disposed(by: self.disposeBag)
//
//    waitForExpectations(timeout: 1, handler: nil)
//
//    // Then
//    let viewStateExpectedResults: [HomeViewModel.State] = [.loading(true), .loading(true), .empty, .loading(false)]
//    XCTAssertEqual(viewStateExpectedResults, viewStateCollector.items, "Invalid events for .empty state.")
//    XCTAssertTrue(pokemonCellModelsCollector.items.first!.isEmpty, "pokemonCellModels is not empty")
//}

//func testEmptyStateUsingRxTest() { // Keep here for future reference...
//    // Given
//    let body1 = "{}".data(using: String.Encoding.utf8)!
//    let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=150")!
//    let request = URLRequest(url: url)
//    URLSession.mockNext(request: request, body: body1, delay: 1)
//
//    // When
//    let sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services:  PokemonService())
//    let viewStateResults = testScheduler.createObserver(HomeViewModel.State.self)
//    let pokemonCellModelsResults = testScheduler.createObserver([PokemonTableViewCellModel].self)
//
//    testScheduler.scheduleAt(0) {
//        sut.viewState.subscribe(viewStateResults.asObserver()).disposed(by: self.disposeBag)
//        sut.pokemonCellModels.subscribe(pokemonCellModelsResults.asObserver()).disposed(by: self.disposeBag)
//    }
//    testScheduler.start()
//
//    let loadPokemonsExpectation = expectation(description: "loadPokemons() fetched a result")
//    sut.loadPokemons().subscribe(onCompleted: {
//        loadPokemonsExpectation.fulfill()
//    }).disposed(by: self.disposeBag)
//
//    waitForExpectations(timeout: 1, handler: nil)
//
//    // Then
//    let viewStateExpectedResults: [HomeViewModel.State] = [.loading(true), .loading(true), .empty, .loading(false)]
//    var colectedViewStates = [HomeViewModel.State]()
//    for event in viewStateResults.events {
//        guard let element = event.value.element else { return }
//        colectedViewStates.append(element)
//    }
//    XCTAssertEqual(viewStateExpectedResults, colectedViewStates, "Invalid events for .empty state.")
//
//
//    var colectedPokemonCellModels = [[PokemonTableViewCellModel]]()
//    for event in pokemonCellModelsResults.events {
//        guard let element = event.value.element else { return }
//        colectedPokemonCellModels.append(element)
//    }
//    XCTAssertTrue(colectedPokemonCellModels.first!.isEmpty, "pokemonCellModels is not empty")
//}
