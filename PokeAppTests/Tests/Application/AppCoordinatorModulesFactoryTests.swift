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
        let router = Router()
        // When
        let (tabBarCoordinator, tabBarController) = sut.build(.tabBar(router: router))
        // Then
//        XCTAssertEqual(type(of: tabBarCoordinator), type(of: TabBarCoordinator), "Invalid types.")
//        XCTAssertEqual(type(of: tabBarController), type(of: TabBarViewController))
    }
    
}
