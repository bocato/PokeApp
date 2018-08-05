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
        
        let taskHandler = { (completionHandler: CompletionHandler?) -> (MockSessionDataTask) -> Void in
            guard let completionHandler = completionHandler else {
                // if the completion handler is not set, respond to the session delegate
                return self.respondToDelegate(request: request, extractions: extractions, session: session)
            }
            // if we have a completion handler set, respond to it
            return self.respondToCompletionHandler(request: request, extractions: extractions, completionHandler: completionHandler)
        }(completionHandler)
        
        let task = MockSessionDataTask(onResume: {task in
            task._state = .running
            taskHandler(task)
        })
        task._originalRequest = request
        
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

// MARK: - Completion Handler responder
private extension DefaultSessionMock {
    
    func respondToCompletionHandler(request: URLRequest, extractions: [String], completionHandler: @escaping CompletionHandler) -> (MockSessionDataTask) -> Void {
        return { task in
            let response = self.mockResponse(request.url!, extractions)
            switch response {
            case .success(let statusCode, let headers, let body):
                let urlResponse = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: headers)!
                completionHandler(body, urlResponse, nil)
            case .failure(let error):
                let urlResponse = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: "HTTP/1.1", headerFields: [:])!
                completionHandler(nil, urlResponse, error)
            }
        }
    }
    
}

// MARK: - Session delegate responder
private extension DefaultSessionMock {
    
    func respondToDelegate(request: URLRequest, extractions: [String], session: URLSession) -> (MockSessionDataTask) -> Void {
        return { task in
            let response = self.mockResponse(request.url!, extractions)
            switch response {
            case let .success(statusCode, headers, body):
                self.respondToDelegateWith(request: request, session: session, task: task, statusCode: statusCode, headers: headers, body: body)
            case let .failure(error):
                self.respondToDelegateWith(request: request, session: session, task: task, error: error)
            }
        }
    }
    
    func respondToDelegateWith(request: URLRequest, session: URLSession, task: MockSessionDataTask, statusCode: Int, headers: [String:String], body: Data?) {
        
        let timeDelta = 0.02
        var time = self.delay
        
        if let delegate = session.delegate as? URLSessionDataDelegate {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: headers)!
                task.response = response
                delegate.urlSession?(session, dataTask: task, didReceive: response) { _ in }
            }
            
            time += timeDelta
            
            if let body = body {
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    delegate.urlSession?(session, dataTask: task, didReceive: body)
                }
                time += timeDelta
            }
            
        }
        
        if let delegate = session.delegate as? URLSessionTaskDelegate {
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                delegate.urlSession?(session, task: task, didCompleteWithError: nil)
                task._state = .completed
            }
        }
        
    }
    
    func respondToDelegateWith(request: URLRequest, session: URLSession, task: MockSessionDataTask, error: NSError) {
        if let delegate = session.delegate as? URLSessionTaskDelegate {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                delegate.urlSession?(session, task: task, didCompleteWithError: error)
                task._state = .completed
            }
        }
    }
    
}

// MARK: - Equatable
extension DefaultSessionMock: Equatable {
    
    static func ==(lhs: DefaultSessionMock, rhs: DefaultSessionMock) -> Bool {
        return lhs === rhs
    }
    
}
