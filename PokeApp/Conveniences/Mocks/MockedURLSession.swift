//
//  MockURLSession.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 31/07/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

public final class MockedURLSession : URLSessionProtocol {
    
    // MARK: Properties
    var request: URLRequest?
    private let mockedURLSessionDataTask: MockedURLSessionDataTask
    
    public convenience init?(jsonDict: [String: AnyObject], response: URLResponse? = nil, error: Error? = nil) {
        guard let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: []) else { return nil }
        self.init(data: data, response: response, error: error)
    }
    
    public init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        mockedURLSessionDataTask = MockedURLSessionDataTask()
        mockedURLSessionDataTask.taskResponse = (data, response, error)
    }
    
    func dataTask(with request: NSURLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        self.request = request as URLRequest
        self.mockedURLSessionDataTask.completionHandler = completionHandler
        return self.mockedURLSessionDataTask
    }
    
    final private class MockedURLSessionDataTask : URLSessionDataTask {
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        var taskResponse: (Data?, URLResponse?, Error?)?
        private(set) var resumeWasCalled = false
        private(set) var cancelWasCalled = false
        
        override func resume() {
            DispatchQueue.main.async {
                self.resumeWasCalled = true
                self.completionHandler?(self.taskResponse?.0, self.taskResponse?.1, self.taskResponse?.2)
            }
        }
        
        override func cancel() {
            cancelWasCalled = true
        }
        
    }
    
}




