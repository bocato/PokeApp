//
//  SessionMock.swift
//  PokeAppUITests
//
//  Created by Eduardo Sanches Bocato on 05/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

/**
 Protocol implemented by all recorded mocks for a session
 */
protocol SessionMock {
    
    // MARK: - Aliases
    typealias CompletionHandler = ((Data? , URLResponse?, Error?) -> Void)
    
    /**
     For a given request, return `true` if this mock matches it (i.e. will return
     a data task from `consumeRequest(request:session:)`.
     */
    func matches(request: URLRequest) -> Bool
    
    /**
     For a given request, this method will return a data task. This method will
     throw if it's asked to consume a request that it doesn't match
     */
    func consume(request: URLRequest, completionHandler: CompletionHandler?, session: URLSession) throws -> URLSessionDataTask
}

enum SessionMockError: Error {
    case invalidRequest(request: URLRequest)
    case hasAlreadyRun
}

/**
 A default delay to use when mocking requests
 */
public var DefaultSessionMockDelay: Double = 0.25
