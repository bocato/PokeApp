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

//    func testSendAndReceiveOutput() {
//        // Given
//        let childCoordinator = CoordinatorSpy(router: Router())
//        let _ = sut.addChildCoordinator(childCoordinator)
//        enum TestOutput: CoordinatorOutput {
//            case test
//        }
//        let outputToSend: TestOutput = .test
//        // When
//        childCoordinator.sendOutputToParent(outputToSend)
//        // Then
//        XCTAssertTrue(sut.didReceiveOutputFromChild, "Output was not received")
//        let receivedOutput = sut.lastReceivedOutput as? TestOutput
//        XCTAssertNotNil(receivedOutput, "Invalid output type")
//        XCTAssertEqual(outputToSend, receivedOutput!,  "Invalid output")
//    }

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
    
    @discardableResult
    func addChildCoordinator(_ coordinator: Coordinator) -> Bool {
        if let child = childCoordinators[coordinator.identifier], child === coordinator {
            return false
        }
        coordinator.parentCoordinator = self
        childCoordinators[coordinator.identifier] = coordinator
        coordinator.start()
        return true
    }
    
    @discardableResult
    func removeChildCoordinator(_ coordinator: Coordinator?) -> Bool {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else {
            return false
        }
        if let coordinatorToRemove = childCoordinators[coordinator.identifier], coordinator === coordinatorToRemove {
            childCoordinators.removeValue(forKey: coordinator.identifier)
            coordinatorToRemove.finish()
            return true
        }
        return false
    }
    
    func sendOutputToParent(_ output: CoordinatorOutput) {
        guard let parentCoordinator = parentCoordinator else {
            return
        }
        parentCoordinator.receiveChildOutput(child: self, output: output)
        didSendOutputToParent = true
        lastSentOutput = output
    }
    
    func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
        guard let parentCoordinator = parentCoordinator else {
            return
        }
        parentCoordinator.receiveChildOutput(child: child, output: output)
        didReceiveOutputFromChild = true
        lastReceivedOutput = output
    }

}
