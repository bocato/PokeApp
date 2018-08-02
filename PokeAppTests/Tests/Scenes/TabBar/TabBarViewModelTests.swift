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
    var actionsDelegateStub: TabBarViewControllerActionsDelegateStub!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        actionsDelegateStub = TabBarViewControllerActionsDelegateStub()
        sut = TabBarViewModel(actionsDelegate: actionsDelegateStub)
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
    
    func testActOnSelectedTab() {
        // Given
        guard let actionsDelegateStub = sut.actionsDelegate as? TabBarViewControllerActionsDelegateStub else {
            XCTFail("actionsDelegate is null")
            return
        }
        // When
        actionsDelegateStub.actOnSelectedTab(.home, UINavigationController())
        // Then
        XCTAssertEqual(actionsDelegateStub.lastSelectedTab, .home, "Home was not selected")
        XCTAssertTrue(actionsDelegateStub.actOnSelectedTabWasCalled, "actOnSelectedTab was not called")
    }
    
}

class TabBarViewControllerActionsDelegateStub: TabBarViewControllerActionsDelegate {
    
    // MARK: Control Vars
    var actOnSelectedTabWasCalled = false
    var lastSelectedTab: TabBarViewModel.TabIndex?
    
    // MARK: - TabBarViewControllerActionsDelegate Functions
    func actOnSelectedTab(_ selectedTab: TabBarViewModel.TabIndex, _ navigationController: UINavigationController) {
        if navigationController.viewControllers.isEmpty {
            self.lastSelectedTab = selectedTab
            self.actOnSelectedTabWasCalled = true
        }
    }
    
}

