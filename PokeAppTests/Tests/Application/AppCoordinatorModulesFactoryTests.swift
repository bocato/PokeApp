//
//  AppCoordinatorModulesFactoryTests.swift
//  PokeAppTests
//
//  Created by Eduardo Bocato on 02/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class AppCoordinatorModulesFactoryTests: XCTestCase {
    
    // MARK: - Properties
    let sut = AppCoordinatorModulesFactory()
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }
    
    // MARK: Tests
    func testBuildTabBarModule() {
        // Given
        let router = SimpleRouter()
        // When
        let (coordinator, controller) = sut.build(.tabBar(router: router))
        let tabBarCoordinator = coordinator as? TabBarCoordinator
        let tabBarController = controller as? TabBarViewController
        // Then
        XCTAssertNotNil(tabBarCoordinator)
        XCTAssertNotNil(tabBarController)
    }
    
}
