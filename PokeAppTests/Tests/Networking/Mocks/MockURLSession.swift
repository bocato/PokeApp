//
//  MockURLSession.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 31/07/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
@testable import PokeApp

class MockURLSession: URLSessionProtocol {
    
    // MARK: Types
    typealias TaskResponse = MockURLSessionDataTask.TaskResponse
    typealias CompletionHandler = MockURLSessionDataTask.CompletionHandler
    
    // MARK: Properties
    private(set) var request: URLRequest?
    private var mockedURLSessionDataTask: MockURLSessionDataTask
    
    convenience init?(jsonDict: [String: AnyObject], response: URLResponse? = nil, error: Error? = nil) {
        guard let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: []) else { return nil }
        self.init(data: data, response: response, error: error)
    }
    
    public init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        let taskResponse = (data, response, error)
        mockedURLSessionDataTask = MockURLSessionDataTask(taskResponse: taskResponse, completionHandler: nil)
    }
    
    // MARK: Functions
    func dataTask(with request: NSURLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return mockedURLSessionDataTask
    }
    
}
