//
//  TabBarCoordinatorModulesFactoryTests.swift
//  PokeAppTests
//
//  Created by Eduardo Bocato on 02/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class TabBarCoordinatorModulesFactoryTests: XCTestCase { // Delete?
    
    // MARK: - Properties
    let sut = TabBarCoordinatorModulesFactory()
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }
    
    // MARK: Tests
    func testBuildHomeModule() {
        // Given
        let navigationController = UINavigationController()
        // When
        let (coordinator, controller) = sut.build(.home(navigationController))
        let homeCoordinator = coordinator as? HomeCoordinator
        let homeViewController = controller as? HomeViewController
        // Then
        XCTAssertNotNil(homeCoordinator)
        XCTAssertNotNil(homeViewController)
    }
    
    func testBuildFavoritesModule() {
        // Given
        let navigationController = UINavigationController()
        // When
        let (coordinator, controller) = sut.build(.favorites(navigationController))
        let favoritesCoordinator = coordinator as? FavoritesCoordinator
        let favoritesViewController = controller as? FavoritesViewController
        // Then
        XCTAssertNotNil(favoritesCoordinator)
        XCTAssertNotNil(favoritesViewController)
    }
    
}
