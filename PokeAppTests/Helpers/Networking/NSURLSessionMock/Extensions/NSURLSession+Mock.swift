//
//  NSURLSession+Mock.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 05/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

public enum RequestDebugLevel: Int {
    case none
    case mocked
    case unmocked
    case all // requests whether they match a mock or not
}

public struct MockReference { // this can be passed back in to determine the state of a mock
    fileprivate let session: DefaultSessionMock
}

extension URLSession {
    
    internal static let currentMocks = MockRepository<DefaultSessionMock>()
    
    /**
     The next call exactly matching `request` will successfully return `body`
     - parameter request: The request to mock
     - parameter body: The data returned by the session data task. If this is `nil` then the didRecieveData callback won't be called.
     - parameter headers: The headers returned by the session data task
     - parameter statusCode: The status code (default=200) returned by the session data task
     - parameter delay: A artificial delay before the session data task starts to return response and data
     */
    @discardableResult
    public class func mockNext(request: URLRequest, body: Data?, headers: [String: String] = [:], statusCode: Int = 200, delay: Double = DefaultSessionMockDelay) -> MockReference {
        let requestMatcher = DefaultRequestMatcher(url: request.url!, method: request.httpMethod!)
        return mock(next: requestMatcher, delay: delay, response: { (url, extractions) -> MockResponse in
            return .success(statusCode: statusCode, headers: headers, body: body)
        })
    }
    
    /**
     All calls exactly matching `request` will successfully return `body`
     - parameter request: The request to mock
     - parameter body: The data returned by the session data task. If this is `nil` then the didRecieveData callback won't be called.
     - parameter headers: The headers returned by the session data task
     - parameter statusCode: The status code (default=200) returned by the session data task
     - parameter delay: A artificial delay before the session data task starts to return response and data
     */
    public class func mockEvery(request: URLRequest, body: Data?, headers: [String: String] = [:], statusCode: Int = 200, delay: Double = DefaultSessionMockDelay) {
        let requestMatcher = DefaultRequestMatcher(url: request.url!, method: request.httpMethod!)
        mock(every: requestMatcher, delay: delay) { (url, extractions) -> MockResponse in
            return .success(statusCode: statusCode, headers: headers, body: body)
        }
    }
    
    /**
     The next call matching `expression` will successfully return `body`
     - parameter expression: The regular expression to compare incoming requests against
     - parameter HTTPMethod: The method to match against
     - parameter body: The data returned by the session data task. If this is `nil` then the didRecieveData callback won't be called.
     - parameter headers: The headers returned by the session data task
     - parameter statusCode: The status code (default=200) returned by the session data task
     - parameter delay: A artificial delay before the session data task starts to return response and data
     */
    @discardableResult
    public class func mockNext(expression: String, httpMethod: String = "GET", body: Data?, headers: [String: String] = [:], statusCode: Int = 200, delay: Double = DefaultSessionMockDelay) throws -> MockReference {
        let requestMatcher = try DefaultRequestMatcher(expression: expression, method: httpMethod)
        return mock(next: requestMatcher, delay: delay, response: { (url, extractions) -> MockResponse in
            return .success(statusCode: statusCode, headers: headers, body: body)
        })
    }
    
    /**
     All subsequent requests matching `expression` will successfully return `body`
     - parameter expression: The regular expression to compare incoming requests against
     - parameter HTTPMethod: The method to match against
     - parameter body: The data returned by the session data task. If this is `nil` then the didRecieveData callback won't be called.
     - parameter headers: The headers returned by the session data task
     - parameter statusCode: The status code (default=200) returned by the session data task
     - parameter delay: A artificial delay before the session data task starts to return response and data
     */
    public class func mockEvery(expression: String, httpMethod: String = "GET", body: Data?, headers: [String: String] = [:], statusCode: Int = 200, delay: Double = DefaultSessionMockDelay) throws {
        let requestMatcher = try DefaultRequestMatcher(expression: expression, method: httpMethod)
        mock(every: requestMatcher, delay: delay) { (url, extractions) -> MockResponse in
            return .success(statusCode: statusCode, headers: headers, body: body)
        }
    }
    
    /**
     The next request matching `expression` will successfully return the result of `response`, a method where the matched sections of the url are passed in as parameters.
     - parameter expression: The regular expression to compare incoming requests against
     - parameter HTTPMethod: The method to match against
     - parameter headers: The headers returned by the session data task
     - parameter statusCode: The status code (default=200) returned by the session data task
     - parameter delay: A artificial delay before the session data task starts to return response and data
     - parameter response: Returns data the data to be returned by the session data task. If this returns `nil` then the didRecieveData callback won't be called.
     */
    @discardableResult
    public class func mockNext(expression: String, httpMethod: String = "GET", delay: Double = DefaultSessionMockDelay, response: @escaping MockResponseClosure) throws -> MockReference {
        let requestMatcher = try DefaultRequestMatcher(expression: expression, method: httpMethod)
        return mock(next: requestMatcher, delay: delay, response: response)
    }
    
    /**
     All subsequent requests matching `expression` will successfully return the result of `response`, a method where the matched sections of the url are passed in as parameters.
     - parameter expression: The regular expression to compare incoming requests against
     - parameter HTTPMethod: The method to match against
     - parameter headers: The headers returned by the session data task
     - parameter statusCode: The status code (default=200) returned by the session data task
     - parameter delay: A artificial delay before the session data task starts to return response and data
     - parameter response: Returns data the data to be  returned by the session data task. If this returns `nil` then the didRecieveData callback won't be called.
     */
    public class func mockEvery(expression: String, httpMethod: String = "GET", delay: Double = DefaultSessionMockDelay, response: @escaping MockResponseClosure) throws {
        let requestMatcher = try DefaultRequestMatcher(expression: expression, method: httpMethod)
        mock(every: requestMatcher, delay: delay, response: response)
    }
    
    /**
     Remove all mocks - NSURLSession will behave as if it had never been touched
     */
    public class func removeAllMocks() {
        currentMocks.removeAllMocks()
        DebugLog(prefix: "MockedURLSession", format: "All mocks are removed")
    }
    
    /**
     Remove all mocks matching the given request. All other requests will still
     be mocked
     */
    public class func removeAllMocks(of request: URLRequest) {
        currentMocks.removeAllMocks(of: request)
        DebugLog(prefix: "MockedURLSession", format: "\(request.url!) mocks are removed")
    }
    
    /**
     For a given MockReference, has it been consumed or not?
     - paramater handle: The returned handle from a call to mock a request i.e. mockSingle(...)
     */
    public class func hasMockConsumed(mockReference: MockReference) -> Bool {
        return !currentMocks.contains(temporary: mockReference.session)
    }
    
}

// MARK: Private methods
private extension URLSession {
    
    // Add a request requestMatcher to the list of mocks
    class func mock(next requestMatcher: RequestMatcher, delay: Double, response: @escaping MockResponseClosure) -> MockReference {
        let mockReference = MockReference(session: DefaultSessionMock(matching: requestMatcher, response: response, delay: delay))
        currentMocks.add(temporary: mockReference.session)
        self.swizzleIfNeeded()
        return mockReference
    }
    
    // Add a request requestMatcher to the list of mocks
    class func mock(every requestMatcher: RequestMatcher, delay: Double, response: @escaping MockResponseClosure) {
        let mock = DefaultSessionMock(matching: requestMatcher, response: response, delay: delay)
        currentMocks.add(permanent: mock)
        self.swizzleIfNeeded()
    }
    
}
