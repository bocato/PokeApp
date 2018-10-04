//
//  DefaultSessionMock.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 05/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

class DefaultSessionMock: SessionMock {
    
    // MARK: - Types
    typealias CompletionHandler = ((Data?, URLResponse?, Error?) -> Void)
    
    private let requestMatcher: RequestMatcher
    private let mockResponse: MockResponseClosure
    private let delay: Double
    
    init(matching requestMatcher: RequestMatcher, response: @escaping MockResponseClosure, delay: Double) {
        self.requestMatcher = requestMatcher
        self.mockResponse = response
        self.delay = delay
    }
    
    private func createURLSessionDataTask(from extractions: [String], request: URLRequest, completionHandler: CompletionHandler?, session: URLSession) -> URLSessionDataTask {
       
        let task = MockSessionDataTask() { task in
            
            let response = self.mockResponse(request.url!, extractions)
            
            switch(response) {
            case let .success(statusCode, headers, body):
                task.scheduleMockedSuccessResponse(with: request, session: session, delay: self.delay, statusCode: statusCode, headers: headers, body: body, completionHandler: completionHandler)
            case let .failure(error):
                task.scheduleMockedErrorResponses(with: request, session: session, delay: self.delay, error: error, completionHandler: completionHandler)
            }
            
        }
        
        return task
    }
    
    func consume(request: URLRequest, completionHandler: CompletionHandler?, session: URLSession) throws -> URLSessionDataTask {
        let matches = requestMatcher.matches(request: request)
        switch matches {
        case .noMatch: // if we have no match, then pass it on to be handled elsewhere
            throw SessionMockError.invalidRequest(request: request)
        case .matches(extractions: let extractions): //
            return createURLSessionDataTask(from: extractions, request: request, completionHandler: completionHandler, session: session)
        }
    }
    
}

// MARK: - Matching
extension DefaultSessionMock {
    
    func matches(request: URLRequest) -> Bool {
        switch(self.requestMatcher.matches(request: request)) {
        case .matches: return true
        case .noMatch: return false
        }
    }
    
}

// MARK: - Equatable
extension DefaultSessionMock: Equatable {
    
    static func ==(lhs: DefaultSessionMock, rhs: DefaultSessionMock) -> Bool {
        return lhs === rhs
    }
    
}
