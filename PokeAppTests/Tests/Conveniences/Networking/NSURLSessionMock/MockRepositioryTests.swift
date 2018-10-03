//
//  MockRepositioryTests.swift
//  PokeAppTests
//
//  Created by Eduardo Bocato on 03/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class MockRepositioryTests: XCTestCase {

    // MARK: - Tests
    func testMockRepository_WithPermanentTestMock_ShouldReturnTestMockWithCorrectURL() {
        // Given
        let repository = MockRepository<TestSessionMock>()
        let mock = TestSessionMock(requestString: "test")
        let request = URLRequest(url: URL(string: "http://www.example.com/test")!)
        
        // Then
        repository.add(permanent: mock)
        
        // When
        let returnedMock = repository.nextSessionMock(for: request)
        XCTAssertNotNil(returnedMock)
    }
    
    func testMockRepository_WithTemporaryTestMock_ShouldReturnTestMockWithCorrectURL() {
        // Given
        let repository = MockRepository<TestSessionMock>()
        let mock = TestSessionMock(requestString: "test")
        let request = URLRequest(url: URL(string: "http://www.example.com/test")!)

        // When
        repository.add(temporary: mock)

        // Then
        let returnedMock = repository.nextSessionMock(for: request)
        XCTAssertNotNil(returnedMock)
    }

    func testMockRepository_WithRemoveAll_ShouldNotReturnAnyMocks() {
        // Given
        let repository = MockRepository<TestSessionMock>()
        let mock = TestSessionMock(requestString: "test")
        let request = URLRequest(url: URL(string: "http://www.example.com/test")!)
        
        // When
        repository.add(permanent: mock)
        repository.add(temporary: mock)
        repository.removeAllMocks()
        
        // Then
        let returnedMock = repository.nextSessionMock(for: request)
        XCTAssertNil(returnedMock)
    }

    func testMockRepository_WithTestMockThatDoesntMatchRequest_ShouldReturnNil() {
        // Given
        let repository = MockRepository<TestSessionMock>()
        let mock = TestSessionMock(requestString: "test")
        let request = URLRequest(url: URL(string: "http://www.example.com")!)
        
        // When
        repository.add(permanent: mock)
        repository.add(temporary: mock)

        // Then
        let returnedMock = repository.nextSessionMock(for: request)
        XCTAssertNil(returnedMock)
    }

    func testMockRepository_WithPermanentMockRemovingCertainRequests_ShouldFilterOut() {
        // Given
        let repository = MockRepository<TestSessionMock>()
        let temporaryMockSession = TestSessionMock(requestString: "test")
        let permanentMockSession = TestSessionMock(requestString: "shouldstillbethere")
        let temporaryRequest = URLRequest(url: URL(string: "http://www.example.com/test")!)
        let permanentRequest = URLRequest(url: URL(string: "http://www.example.com/shouldstillbethere")!)
        
        // When
        repository.add(permanent: temporaryMockSession)
        repository.add(permanent: permanentMockSession)
        repository.removeAllMocks(of: temporaryRequest)

        // Then
        let permanentMock = repository.nextSessionMock(for: permanentRequest)
        let temporaryMockThaWasRemoved = repository.nextSessionMock(for: temporaryRequest)

        XCTAssertNotNil(permanentMock)
        XCTAssertNil(temporaryMockThaWasRemoved)
    }

    func testMockRepository_WithTemporaryMockRemovingCertainRequests_ShouldFilterOut() {
        // Given
        let repository = MockRepository<TestSessionMock>()
        let temporaryMockSession = TestSessionMock(requestString: "test")
        let permanentMockSession = TestSessionMock(requestString: "shouldstillbethere")
        let temporaryRequest = URLRequest(url: URL(string: "http://www.example.com/test")!)
        let permanentRequest = URLRequest(url: URL(string: "http://www.example.com/shouldstillbethere")!)

        // When
        repository.add(temporary: temporaryMockSession)
        repository.add(temporary: permanentMockSession)
        repository.removeAllMocks(of: temporaryRequest)

        // Then
        let permanentMock = repository.nextSessionMock(for: permanentRequest)
        let temporaryMockThaWasRemoved = repository.nextSessionMock(for: temporaryRequest)

        XCTAssertNotNil(permanentMock)
        XCTAssertNil(temporaryMockThaWasRemoved)
    }

//    func testMockRepository_WithTemporaryMock_ShouldRemoveAfterReturning() {
//        let register = MockRepository<TestTemporaryMock>()
//        let mock = TestTemporaryMock(requestString: "test")
//
//        repository.add(Temporary: mock)
//
//        let request = URLRequest(url: URL(string: "http://www.example.com/test")!)
//        let notNilMock = repository.nextSessionMock(for: request)
//        let nilMock = repository.nextSessionMock(for: request)
//        XCTAssertNil(nilMock)
//        XCTAssertNotNil(notNilMock)
//    }
//
//    func testMockRepository_WithTemporaryAndPermanentMock_ShouldPrioritizeTemporaryMock() {
//
//        let repository = MockRegister<TestSessionMock>()
//        let mock = TestSessionMock(requestString: "example.com/test")
//        let permanentMock = TestSessionMock(requestString: "test")
//        let secondPermanentMock = TestSessionMock(requestString: "test")
//
//        repository.add(permanent: permanentMock)
//        repository.add(Temporary: mock)
//        repository.add(permanent: secondPermanentMock)
//
//        let request = URLRequest(url: URL(string: "http://www.example.com/test")!)
//        guard let Temporary = repository.nextSessionMock(for: request) as? TestSessionMock else {
//            XCTFail("Could not get Temporary mock")
//            return
//        }
//
//        XCTAssertNotNil(Temporary)
//        XCTAssertEqual(Temporary.requestString, "example.com/test")
//    }
//
//    func testMockRepository_WithEquatableMock_ShouldContainTemporaryMock() {
//        let repository = MockRegister<TestSessionMock>()
//        let mock1 = TestSessionMock(requestString: "example.com/test1")
//        let mock2 = TestSessionMock(requestString: "example.com/test2")
//        repository.add(Temporary: mock1)
//        repository.add(permanent: mock2)
//
//        XCTAssertTrue(repository.contains(Temporary: mock1))
//        XCTAssertFalse(repository.contains(Temporary: mock2))
//    }
//
//    func testMockRepository_WithConsumedMock_ShouldNotContainMock() {
//        let repository = MockRepository<TestSessionMock>()
//        let mock = TestSessionMock(requestString: "example.com/test1")
//        repository.add(Temporary: mock)
//
//        // Consume the mock again
//        _ = repository.nextSessionMock(for: URLRequest(url: URL(string: mock.requestString)!))
//        XCTAssertFalse(repository.contains(Temporary: mock))
//
//        // Make sure it's not still contained in the repository
//        XCTAssertFalse(repository.contains(Temporary: mock))
//    }

}

// MARK: - Utils
private class TestSessionMock: SessionMock {
    
    // MARK: - Properties
    let requestString: String
    
    // MARK: - Initialization
    init(requestString: String) {
        self.requestString = requestString
    }
    
    // MAKR: - SessionMock Methods
    func matches(request: URLRequest) -> Bool {
        return (request.url?.absoluteString.contains(requestString)) ?? false
    }
    
    func consume(request: URLRequest, completionHandler: ( (Data?, URLResponse?, Error?) -> Void )?, session: URLSession) throws -> URLSessionDataTask {
        return URLSessionDataTask()
    }
    
}
extension TestSessionMock: Equatable {
    
    static func ==(lhs: TestSessionMock, rhs: TestSessionMock) -> Bool {
        return lhs === rhs
    }
    
}

private class TestTemporaryMock: SessionMock {
    var runsOnce = true
    let requestString: String
    
    init(requestString: String) {
        self.requestString = requestString
    }
    
    func matches(request: URLRequest) -> Bool {
        return (request.url?.absoluteString.contains(requestString))!
    }
    
    func consume(request: URLRequest, completionHandler: ( (Data?, URLResponse?, Error?) -> Void )?, session: URLSession) throws -> URLSessionDataTask {
        return URLSessionDataTask()
    }
}
