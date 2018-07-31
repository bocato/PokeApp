//
//  MockURLSessionDataTask.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 31/07/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
@testable import PokeApp

class MockURLSessionDataTask : URLSessionDataTaskProtocol {
    
    // MARK: Types
    typealias TaskResponse = (Data?, URLResponse?, Error?)?
    typealias CompletionHandler = (TaskResponse?) -> Void
    
    // MARK: Properties
    private(set) var taskResponse: TaskResponse
    private(set) var completionHandler: CompletionHandler?
    private(set) var cancelWasCalled = false
    
    // MARK: - Initialization
    init(taskResponse: TaskResponse = nil, completionHandler: CompletionHandler? = nil) {
        self.taskResponse = taskResponse
        self.completionHandler = completionHandler
    }
    
    // MARK: Functions
    func resume() {
        DispatchQueue.main.async {
            let response = (self.taskResponse?.0, self.taskResponse?.1, self.taskResponse?.2)
            self.completionHandler?(response)
        }
    }
    
    func cancel() {
        cancelWasCalled = true
    }
    
}
