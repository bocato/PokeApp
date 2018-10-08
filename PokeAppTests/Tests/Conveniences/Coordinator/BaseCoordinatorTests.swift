//
//  BaseCoordinatorTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 02/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

//class BaseCoordinatorTests: XCTestCase {
//    
//    // MARK: - Properties
//    var sut: BaseCoordinatorSpy!
//    
//    // MARK: - Lifecycle
//    override func setUp() {
//        super.setUp()
//        sut = BaseCoordinatorSpy(router: Router())
//    }
//    
//    // MARK: Tests
//    func testInit() {
//        // Given
//        let sut: BaseCoordinator?
//        // When
//        sut = BaseCoordinator(router: Router())
//        // Then
//        XCTAssertNotNil(sut, "initalization failed")
//    }
//    
//    func testStart() {
//        // When
//        sut.start()
//        // Then
//        XCTAssertTrue(sut.startWasCalled, "Start was not called")
//    }
//    
//    func testFinish() {
//        // When
//        sut.finish()
//        // Then
//        XCTAssertTrue(sut.finishWasCalled, "Finish was not called")
//    }
//    
//    func testAddChildCoordinatorThatDoesntExist() {
//        // Given
//        let childCoordinator = BaseCoordinatorSpy(router: Router())
//        // When
//        let didAddChild = sut.addChildCoordinator(childCoordinator)
//        // Then
//        XCTAssertTrue(didAddChild, "Child was added")
//        XCTAssertTrue(childCoordinator.startWasCalled, "Start was not called on childCoordinator")
//        XCTAssertTrue(sut.numberOfChildCoordinators == 1, "Wrong number of childs")
//    }
//    
//    func testAddChildCoordinatorThatExists() {
//        // Given
//        let childCoordinator = BaseCoordinatorSpy(router: Router())
//        // When
//        let didAddChild1 = sut.addChildCoordinator(childCoordinator)
//        let didAddChild2 = sut.addChildCoordinator(childCoordinator)
//        // Then
//        XCTAssertTrue(didAddChild1, "Child 1 was added")
//        XCTAssertTrue(childCoordinator.startWasCalled, "Start was not called on childCoordinator")
//        XCTAssertFalse(didAddChild2, "Child 2 was added, but it shouldn't be")
//        XCTAssertTrue(sut.numberOfChildCoordinators == 1, "Wrong number of childs")
//    }
//    
//    func testRemoveChildCoordinatorThatDoesntExist() {
//        // Given
//        testAddChildCoordinatorThatDoesntExist()
//        let childCoordinator2 = BaseCoordinatorSpy(router: Router())
//        // When
//        let didRemoveChild = sut.removeChildCoordinator(childCoordinator2)
//        // Then
//        XCTAssertFalse(didRemoveChild, "Child was removed, but shouldn't be since it doesn't exist")
//        XCTAssertFalse(childCoordinator2.finishWasCalled, "Finish wascalled on childCoordinator, but shouldn't be")
//        XCTAssertTrue(sut.numberOfChildCoordinators == 1, "Wrong number of childs, whe should have one")
//    }
//    
//    func testRemoveNilCoordinator() {
//        // Given
//        testAddChildCoordinatorThatDoesntExist()
//        // When
//        let didRemoveChild = sut.removeChildCoordinator(nil)
//        // Then
//        XCTAssertFalse(didRemoveChild, "Child was removed, but shouldn't be since it doesn't exist")
//        XCTAssertTrue(sut.numberOfChildCoordinators == 1, "Wrong number of childs, whe should have one")
//    }
//    
//    func testRemoveChildCoordinatorThatExists() {
//        // Given
//        let childCoordinator = BaseCoordinatorSpy(router: Router())
//        let _ = sut.addChildCoordinator(childCoordinator)
//        // When
//        let didRemoveChild = sut.removeChildCoordinator(childCoordinator)
//        // Then
//        XCTAssertTrue(didRemoveChild, "Child was not removed")
//        XCTAssertTrue(childCoordinator.finishWasCalled, "Finish was not called on childCoordinator")
//        XCTAssertTrue(sut.numberOfChildCoordinators == 0, "Wrong number of childs")
//    }
//    
//    func testSendAndReceiveOutput() {
//        // Given
//        let childCoordinator = BaseCoordinatorSpy(router: Router())
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
//    
//}
//
//class BaseCoordinatorSpy: BaseCoordinator {
//    
//    // MARK: - Control Variables
//    var initWasCalled = false
//    var startWasCalled = false
//    var finishWasCalled = false
//    var numberOfChildCoordinators = 0
//    var didReceiveOutputFromChild = false
//    var lastReceivedOutput: CoordinatorOutput?
//    
//    // MARK: - Methods
//    override func start() {
//        super.start()
//        startWasCalled = true
//    }
//    
//    override func finish() {
//        super.finish()
//        finishWasCalled = true
//    }
//    
//    override func addChildCoordinator(_ coordinator: Coordinator) -> Bool {
//        let didAddChild = super.addChildCoordinator(coordinator)
//        if didAddChild {
//            numberOfChildCoordinators += 1
//        }
//        return didAddChild
//    }
//    
//    override func removeChildCoordinator(_ coordinator: Coordinator?) -> Bool {
//        let didRemoveChild = super.removeChildCoordinator(coordinator)
//        if didRemoveChild {
//            numberOfChildCoordinators -= 1
//        }
//        return didRemoveChild
//    }
//    
//    override func sendOutputToParent(_ output: CoordinatorOutput) {
//        super.sendOutputToParent(output)
//    }
//    
//    override func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
//        super.receiveChildOutput(child: child, output: output)
//        lastReceivedOutput = output
//        didReceiveOutputFromChild = true
//    }
//    
//}
