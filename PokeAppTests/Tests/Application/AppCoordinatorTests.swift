//
//  AppCoordinatorTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 06/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class AppCoordinatorTests: XCTestCase {
    
    // MARK: Tests
    func testLaunchInstructorResourceLoaderTrue() {
        let appStartPoint = AppCoordinator.LaunchInstructor.getApplicationStartPoint(showResourcesLoader: true)
        XCTAssertEqual(appStartPoint, .resourceLoader, "Unexpected start point.")
    }
    
    func testLaunchInstructorResourceLoaderFalse() {
        let appStartPoint = AppCoordinator.LaunchInstructor.getApplicationStartPoint(showResourcesLoader: false)
        XCTAssertEqual(appStartPoint, .tabBar, "Unexpected start point.")
    }
    
    
    func testBuildNil() {
        let appCoordinator = AppCoordinator.build(window: nil)
        XCTAssertNil(appCoordinator)
    }
    
    func testDefaultsBuild() {
        // Given
        let window = UIWindow()
        window.rootViewController = UINavigationController()
        // When
        let appCoordinator = AppCoordinator.build(window: window)
        // Then
        XCTAssertNotNil(appCoordinator)
    }

    func testBuildWithParameters() {
        // Given
        let window = UIWindow()
        window.rootViewController = UINavigationController()
        let modulesFactory = AppCoordinatorModulesFactory()
        // When
        let appCoordinator = AppCoordinator.build(window: window, modulesFactory: modulesFactory, showResourceLoader: false)
        // Then
        XCTAssertNotNil(appCoordinator)
    }
    
    func testStartWithMainFlow() {
        // Given
        let window = UIWindow()
        window.rootViewController = UINavigationController()
        let modulesFactory = AppCoordinatorModulesFactory()
        // When
        let appCoordinator = AppCoordinator.build(window: window, modulesFactory: modulesFactory, showResourceLoader: false)!
        appCoordinator.start()
        // Then
        let containsTabBarCoordinator = appCoordinator.childCoordinators.contains { (key, value) -> Bool in
            return key == "TabBarCoordinator"
        }
        XCTAssertTrue(containsTabBarCoordinator)
    }
    
    func testStartWithResourceLoader() {
        // Given
        let window = UIWindow()
        window.rootViewController = UINavigationController()
        let modulesFactory = AppCoordinatorModulesFactory()
        // When
        let appCoordinator = AppCoordinator.build(window: window, modulesFactory: modulesFactory, showResourceLoader: true)!
        appCoordinator.start()
        // Then
        let containsTabBarCoordinator = appCoordinator.childCoordinators.contains { (key, value) -> Bool in
            return key == "TabBarCoordinator"
        }
        XCTAssertFalse(containsTabBarCoordinator)
    }

}
