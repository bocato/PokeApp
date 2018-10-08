//
//  CoordinatorTests.swift
//  PokeAppTests
//
//  Created by Eduardo Bocato on 08/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class CoordinatorTests: XCTestCase {

    // MARK: - Properties
    var sut: CoordinatorSpy!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = CoordinatorSpy(router: Router())
    }

    // MARK: Tests
    func testInit() {
        // Given
        let sut: Coordinator?
        // When
        sut = CoordinatorSpy(router: Router())
        // Then
        XCTAssertNotNil(sut, "initalization failed")
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
        XCTAssertTrue(sut.finishWasCalled, "Finish was not called")
    }

    func testAddChildCoordinatorThatDoesntExist() {
        // Given
        let childCoordinator = CoordinatorSpy(router: Router())
        // When
        let didAddChild = sut.addChildCoordinator(childCoordinator)
        // Then
        XCTAssertTrue(didAddChild, "Child was added")
        XCTAssertTrue(childCoordinator.startWasCalled, "Start was not called on childCoordinator")
        XCTAssertTrue(sut.numberOfChildCoordinators == 1, "Wrong number of childs")
    }

    func testAddChildCoordinatorThatExists() {
        // Given
        let childCoordinator = CoordinatorSpy(router: Router())
        // When
        let didAddChild1 = sut.addChildCoordinator(childCoordinator)
        let didAddChild2 = sut.addChildCoordinator(childCoordinator)
        // Then
        XCTAssertTrue(didAddChild1, "Child 1 was added")
        XCTAssertTrue(childCoordinator.startWasCalled, "Start was not called on childCoordinator")
        XCTAssertFalse(didAddChild2, "Child 2 was added, but it shouldn't be")
        XCTAssertTrue(sut.numberOfChildCoordinators == 1, "Wrong number of childs")
    }

    func testRemoveChildCoordinatorThatDoesntExist() {
        // Given
        testAddChildCoordinatorThatDoesntExist()
        let childCoordinator2 = CoordinatorSpy(router: Router())
        // When
        let didRemoveChild = sut.removeChildCoordinator(childCoordinator2)
        // Then
        XCTAssertFalse(didRemoveChild, "Child was removed, but shouldn't be since it doesn't exist")
        XCTAssertFalse(childCoordinator2.finishWasCalled, "Finish wascalled on childCoordinator, but shouldn't be")
        XCTAssertTrue(sut.numberOfChildCoordinators == 1, "Wrong number of childs, whe should have one")
    }

    func testRemoveNilCoordinator() {
        // Given
        testAddChildCoordinatorThatDoesntExist()
        // When
        let didRemoveChild = sut.removeChildCoordinator(nil)
        // Then
        XCTAssertFalse(didRemoveChild, "Child was removed, but shouldn't be since it doesn't exist")
        XCTAssertTrue(sut.numberOfChildCoordinators == 1, "Wrong number of childs, whe should have one")
    }

    func testRemoveChildCoordinatorThatExists() {
        // Given
        let childCoordinator = CoordinatorSpy(router: Router())
        let _ = sut.addChildCoordinator(childCoordinator)
        // When
        let didRemoveChild = sut.removeChildCoordinator(childCoordinator)
        // Then
        XCTAssertTrue(didRemoveChild, "Child was not removed")
        XCTAssertTrue(childCoordinator.finishWasCalled, "Finish was not called on childCoordinator")
        XCTAssertTrue(sut.numberOfChildCoordinators == 0, "Wrong number of childs")
    }

    func testSendOutputToParent() {
        // Given
        let router = Router()
        let childCoordinator = CoordinatorSpy(router: router)
        let didAddChildCoordinator = sut.addChildCoordinator(childCoordinator)
        
        XCTAssertEqual(childCoordinator.parentCoordinator?.identifier, sut.identifier)
        XCTAssertTrue(didAddChildCoordinator)
        
        enum TestOutput: CoordinatorOutput {
            case test
        }
        let outputToSend: TestOutput = .test
        
        // When
        childCoordinator.sendOutputToParent_spy(outputToSend)
        
        // Then
        XCTAssertTrue(childCoordinator.didSendOutputToParent)
        let lastSentOutput = childCoordinator.lastSentOutput as? TestOutput
        XCTAssertNotNil(lastSentOutput)
    }

}

class CoordinatorSpy: Coordinator {
    
    // MARK: - Dependencies
    internal(set) var router: RouterProtocol
    
    // MARK: - Properties
    weak internal(set) var delegate: CoordinatorDelegate?
    internal(set) var childCoordinators: [String : Coordinator] = [:]
    internal(set) weak var parentCoordinator: Coordinator? = nil
    internal(set) var context: CoordinatorContext? // This is a struct
    
    // MARK: - Control Variables
    var initWasCalled = false
    var startWasCalled = false
    var finishWasCalled = false
    var numberOfChildCoordinators: Int {
        return childCoordinators.keys.count
    }
    var didSendOutputToParent = false
    var lastSentOutput: CoordinatorOutput?
    var didReceiveOutputFromChild = false
    var lastReceivedOutput: CoordinatorOutput?

    // MARK: - Intialization
    init(router: RouterProtocol) {
        self.router = router
    }
    
    // MARK: - Methods
    func start() {
        startWasCalled = true
    }

    func finish() {
        finishWasCalled = true
    }
    
    func sendOutputToParent_spy(_ output: CoordinatorOutput) {
        sendOutputToParent(output)
        didSendOutputToParent = true
        lastSentOutput = output
    }

}
