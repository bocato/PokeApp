//
//  FavoritesCoordinatorTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 06/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class FavoritesCoordinatorTests: XCTestCase {

    // MARK: - Properties
    var coordinatorDelegateSpy: CoordinatorDelegateSpy!
    var sut: FavoritesCoordinatorSpy!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        let router = Router()
        let modulesFactory = FavoritesCoordinatorModulesFactory()
        coordinatorDelegateSpy = CoordinatorDelegateSpy()
        sut = FavoritesCoordinatorSpy(router: router, modulesFactory: modulesFactory, favoritesManager: SimpleFavoritesManager.shared)
        sut.delegate = coordinatorDelegateSpy
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests
    func testReceivingDidAddPokemonOutputFromDetailsCoordinator() {
        // Given
        let router = Router()
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
        let router = Router()
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

class FavoritesCoordinatorSpy: FavoritesCoordinator {
    
    // MARK: - Control Variables [FavoritesCoordinator]
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
    
    // MARK: - FavoritesViewControllerActionsDelegate
    override func showItemDetailsForPokemonWith(id: Int) {
        showItemDetailsForPokemonWithIdWasCalled = true
        idForLastPokemonDetailsRequest = id
        super.showItemDetailsForPokemonWith(id: id)
    }
    
}
