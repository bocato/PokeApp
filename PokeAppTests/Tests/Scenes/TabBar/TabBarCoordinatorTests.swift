//
//  TabBarCoordinatorTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 06/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class TabBarCoordinatorTests: XCTestCase {

    // MARK: - Properties
    var coordinatorDelegateSpy: CoordinatorDelegateSpy!
    var sut: TabBarCoordinatorSpy!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        let router = Router()
        let modulesFactory = TabBarCoordinatorModulesFactory()
        coordinatorDelegateSpy = CoordinatorDelegateSpy()
        sut = TabBarCoordinatorSpy(router: router, modulesFactory: modulesFactory)
        sut.delegate = coordinatorDelegateSpy
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Tests
    func testReceiveChildOutputFromFavoritesCoordinator() {
        // Given
        let favoritesCoordinator = FavoritesCoordinator(router: Router(), modulesFactory: FavoritesCoordinatorModulesFactory(), favoritesManager: SimpleFavoritesManager.shared)
        sut.addChildCoordinator(favoritesCoordinator)
        let outputToSend: FavoritesCoordinator.Output = .shouldReloadFavorites
        
        // When
        favoritesCoordinator.sendOutputToParent(outputToSend)
        
        // Then
        let childWhoSentTheLastOutput = sut.childWhoSentTheLastOutput as? FavoritesCoordinator
        XCTAssertNotNil(childWhoSentTheLastOutput)
        XCTAssertEqual(childWhoSentTheLastOutput!.identifier, favoritesCoordinator.identifier, "Invalid child.")
        
        let lastReceivedChildOutput = sut.lastReceivedChildOutput as? FavoritesCoordinator.Output
        XCTAssertNotNil(lastReceivedChildOutput)
        XCTAssertEqual(lastReceivedChildOutput, outputToSend, "Invalid output.")
    }
    
    func testReceiveChildOutputFromHomeCoordinator() {
        // Given
        let homeCoordinator = HomeCoordinator(router: Router(), favoritesManager: SimpleFavoritesManager.shared, modulesFactory: HomeCoordinatorModulesFactory())
        sut.addChildCoordinator(homeCoordinator)
        let outputToSend: HomeCoordinator.Output = .shouldReloadFavorites
        
        // When
        homeCoordinator.sendOutputToParent(outputToSend)
        
        // Then
        let childWhoSentTheLastOutput = sut.childWhoSentTheLastOutput as? HomeCoordinator
        XCTAssertNotNil(childWhoSentTheLastOutput)
        XCTAssertEqual(childWhoSentTheLastOutput!.identifier, homeCoordinator.identifier, "Invalid child.")
        
        let lastReceivedChildOutput = sut.lastReceivedChildOutput as? HomeCoordinator.Output
        XCTAssertNotNil(lastReceivedChildOutput)
        XCTAssertEqual(lastReceivedChildOutput, outputToSend, "Invalid output.")
    }
    
    func testActOnSelectHome() {
        // Given
        let tabBarViewModel = TabBarViewModel(actionsDelegate: sut)
        let navigationController = UINavigationController()

        // When
        tabBarViewModel.actionsDelegate?.actOnSelectedTab(.home, navigationController)

        // Then
        XCTAssertNotNil(tabBarViewModel.actionsDelegate)
        XCTAssertTrue(sut.actOnSelectedTabWasCalled)
        XCTAssertNotNil(sut.lastSelectedTab)
        XCTAssertEqual(sut.lastSelectedTab!, .home, "Invalid tab.")
        XCTAssertNotNil(sut.lastSentNavigationController)
        XCTAssertEqual(sut.lastSentNavigationController!, navigationController, "Invalid NavigationController.")
    }

    func testActOnSelectFavorites() {
        // Given
        let tabBarViewModel = TabBarViewModel(actionsDelegate: sut)
        let navigationController = UINavigationController()

        // When
        tabBarViewModel.actionsDelegate?.actOnSelectedTab(.favorites, navigationController)

        // Then
        XCTAssertTrue(sut.actOnSelectedTabWasCalled)
        XCTAssertNotNil(sut.lastSelectedTab)
        XCTAssertEqual(sut.lastSelectedTab!, .favorites, "Invalid tab.")
        XCTAssertNotNil(sut.lastSentNavigationController)
        XCTAssertEqual(sut.lastSentNavigationController!, navigationController, "Invalid NavigationController.")
    }

}

class TabBarCoordinatorSpy: TabBarCoordinator {
    
    // MARK: - Control Variables [Coordinator]
    var childWhoSentTheLastOutput: Coordinator?
    var lastReceivedChildOutput: CoordinatorOutput?

    // MARK: Control Variables [ActionsDelegate]
    var actOnSelectedTabWasCalled = false
    var lastSelectedTab: TabBarViewModel.TabIndex?
    var lastSentNavigationController: UINavigationController?
    
    // MARK: - Outputs
    override func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
        childWhoSentTheLastOutput = child
        lastReceivedChildOutput = output
        super.receiveChildOutput(child: child, output: output)
    }
    
    // MARK: - TabBarViewControllerActionsDelegate
    override func actOnSelectedTab(_ selectedTab: TabBarViewModel.TabIndex, _ navigationController: UINavigationController) {
        lastSentNavigationController = navigationController
        lastSelectedTab = selectedTab
        actOnSelectedTabWasCalled = true
        super.actOnSelectedTab(selectedTab, navigationController)
    }
    
}
