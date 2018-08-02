//
//  BaseCoordinatorTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 02/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class BaseCoordinatorTests: XCTestCase {
    
    // MARK: - Properties
    var sut: BaseCoordinatorSpy!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        let router = Router() // TODO: implement this with a mock
        sut = BaseCoordinatorSpy(router: router)
    }
    
    // MARK: Tests
    func testInit() {
        XCTAssertTrue(sut.initWasCalled, "Init was not called")
        XCTAssertNotNil(sut.router, "Router not set")
    }
    
    func testStart() {
        // When
        sut.start()
        // Then
        XCTAssertTrue(sut.startWasCalled, "Start was not called")
    }
    
    func testFinish() {
        // When
        sut.finish()
        // Then
        XCTAssertTrue(sut.startWasCalled, "Finish was not called")
    }
    
    func testAddChildCoordinatorThatDoesntExist() {
        // Given
        // When
        // Then
    }
    
    func testAddChildCoordinatorThatExists() {
        // Given
        // When
        // Then
    }
    
    func testRemoveChildCoordinatorThatDoesntExist() {
        // Given
        // When
        // Then
    }
    
    func testRemoveChildCoordinatorThatExists() {
        // Given
        // When
        // Then
    }
    
}

class BaseCoordinatorSpy: BaseCoordinator {
    
    // MARK: - Control Variables
    var initWasCalled = false
    var startWasCalled = false
    var finishWasCalled = false
    var numberOfChildCoordinators = 0
    
    // MARK: - Methods
    override init(router: RouterProtocol) {
        super.init(router: router)
        initWasCalled = true
    }
    
    override func start() {
        startWasCalled = true
    }
    
    override func finish() {
        finishWasCalled = true
    }
    
    override func addChildCoordinator(_ coordinator: Coordinator) {
        super.addChildCoordinator(coordinator)
        numberOfChildCoordinators += 1
    }
    
    override func removeChildCoordinator(_ coordinator: Coordinator?) {
        super.removeChildCoordinator(coordinator)
        numberOfChildCoordinators -= 1
    }
    
}
