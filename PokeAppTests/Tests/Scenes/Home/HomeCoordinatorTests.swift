//
//  HomeCoordinatorTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 06/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class HomeCoordinatorTests: XCTestCase {

    // MARK: - Properties
    var coordinatorDelegateSpy: CoordinatorDelegateSpy!
    var sut: HomeCoordinatorSpy!
    var favoritesManager: FavoritesManager!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        let router = SimpleRouter()
        let modulesFactory = HomeCoordinatorModulesFactory()
        coordinatorDelegateSpy = CoordinatorDelegateSpy()
        favoritesManager = SimpleFavoritesManager.shared
        sut = HomeCoordinatorSpy(router: router, favoritesManager: favoritesManager, modulesFactory: modulesFactory)
        sut.delegate = coordinatorDelegateSpy
    }
    
    override func tearDown() {
        super.tearDown()
        favoritesManager.favorites.removeAll()
    }
    
    // MARK: - Tests
    func testReceivingDidAddPokemonOutputFromDetailsCoordinator() {
        // Given
        let router = SimpleRouter()
        let detailsCoordinator = DetailsCoordinator(router: router)
        sut.addChildCoordinator(detailsCoordinator)
        let outputToSend: DetailsCoordinator.Output = .didAddPokemon
        
        // When
        detailsCoordinator.sendOutputToParent(outputToSend)
        
        // Then
        let childWhoSentTheLastOutput = sut.childWhoSentTheLastOutput as? DetailsCoordinator
        XCTAssertNotNil(childWhoSentTheLastOutput)
        XCTAssertEqual(childWhoSentTheLastOutput!.identifier, detailsCoordinator.identifier, "Invalid child.")
        
        let lastReceivedChildOutput = sut.lastReceivedChildOutput as? DetailsCoordinator.Output
        XCTAssertNotNil(lastReceivedChildOutput)
        XCTAssertEqual(lastReceivedChildOutput, outputToSend, "Invalid output.")
    }
    
    func testReceivingDidRemovePokemonOutputFromDetailsCoordinator() {
        // Given
        let router = SimpleRouter()
        let detailsCoordinator = DetailsCoordinator(router: router)
        sut.addChildCoordinator(detailsCoordinator)
        let outputToSend: DetailsCoordinator.Output = .didRemovePokemon
        
        // When
        detailsCoordinator.sendOutputToParent(outputToSend)
        
        // Then
        let childWhoSentTheLastOutput = sut.childWhoSentTheLastOutput as? DetailsCoordinator
        XCTAssertNotNil(childWhoSentTheLastOutput)
        XCTAssertEqual(childWhoSentTheLastOutput!.identifier, detailsCoordinator.identifier, "Invalid child.")
        
        let lastReceivedChildOutput = sut.lastReceivedChildOutput as? DetailsCoordinator.Output
        XCTAssertNotNil(lastReceivedChildOutput)
        XCTAssertEqual(lastReceivedChildOutput, outputToSend, "Invalid output.")
    }

}

class HomeCoordinatorSpy: HomeCoordinator {
    
    // MARK: - Control Variables [Coordinator]
    var childWhoSentTheLastOutput: Coordinator?
    var lastReceivedChildOutput: CoordinatorOutput?
    
    // MARK: - Control Variables [ActionsDelegate]
    var showItemDetailsForPokemonWithIdWasCalled = false
    var idForLastPokemonDetailsRequest: Int?
    
    // MARK: - Outputs
    override func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
        childWhoSentTheLastOutput = child
        lastReceivedChildOutput = output
        super.receiveChildOutput(child: child, output: output)
    }
    
    // MARK: - HomeViewControllerActionsDelegate
    override func showItemDetailsForPokemonWith(id: Int) {
        showItemDetailsForPokemonWithIdWasCalled = true
        idForLastPokemonDetailsRequest = id
        super.showItemDetailsForPokemonWith(id: id)
    }
    
}
