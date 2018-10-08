//
//  TabBarViewModelTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 31/07/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class TabBarViewModelTests: XCTestCase {
    
    // MARK: - Properties
    var sut: TabBarViewModel!
    var tabBarCoordinator: TabBarCoordinatorSpy!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        tabBarCoordinator = TabBarCoordinatorSpy(router: Router(), modulesFactory: TabBarCoordinatorModulesFactory())
        sut = TabBarViewModel(actionsDelegate: tabBarCoordinator)
    }
    
    // MARK: - Tests
    func testInit() {
        XCTAssertNotNil(sut, "initalization failed")
        XCTAssertNotNil(sut.actionsDelegate, "ActionsDelegate was not set")
        XCTAssertEqual(sut.selectedTab.value, .home, "default selected tab is not Home")
    }
    
    func testSelectHomeTabBar() {
        // Given
        let collector = RxCollector<TabBarViewModel.TabIndex>()
            .collect(from: sut.selectedTab.asObservable())
        // When
        sut.selectedTab.accept(.home)
        // Then
        XCTAssertEqual(collector.items.last!, .home, "selected tab is not Home")
    }
    
    func testSelectFavoritesTabBar() {
        // Given
        let collector = RxCollector<TabBarViewModel.TabIndex>()
            .collect(from: sut.selectedTab.asObservable())
        // When
        sut.selectedTab.accept(.favorites)
        // Then
        XCTAssertEqual(collector.items.last!, .favorites, "selected tab is not Favorites")
    }
    
}
