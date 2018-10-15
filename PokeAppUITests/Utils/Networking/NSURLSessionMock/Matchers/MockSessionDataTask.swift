//
//  MockSessionDataTask.swift
//  PokeAppUITests
//
//  Created by Eduardo Sanches Bocato on 05/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

private var globalTaskIdentifier: Int = 22021990 // Some number bigger than the session would naturally create

class MockSessionDataTask: URLSessionDataTask { // Internal implementation of `NSURLSessionDataTask` with read-write properties.
    
    // MARK: - Properties
    var mockedResponseItems : [DispatchWorkItem]?
    weak var session: URLSession?
    private var mutex: pthread_mutex_t = pthread_mutex_t()
    private var completionHandler: ((Data? , URLResponse?, Error?) -> Void)?
    let onResume: (_ task: MockSessionDataTask)->()
    
    // MARK: - Initialization
    init(onResume: @escaping (_ task: MockSessionDataTask)->()) {
        self.onResume = onResume
    }
    
    // MARK: - Dealing with original properties and adding read-write ones
    var _taskIdentifier: Int = {
        globalTaskIdentifier += 1
        return globalTaskIdentifier
    }()
    override var taskIdentifier: Int {
        return _taskIdentifier
    }
    
    var _originalRequest: URLRequest?
    override var originalRequest: URLRequest? {
        return _originalRequest
    }
    
    var _currentRequest: URLRequest?
    override var currentRequest: URLRequest? {
        return _currentRequest
    }
    
    var _state: URLSessionTask.State = .suspended
    override var state: URLSessionTask.State {
        return _state
    }
    
    private var _taskDescription: String?
    override var taskDescription: String? {
        get { return _taskDescription }
        set { _taskDescription = newValue }
    }
    
    private var _response: URLResponse?
    override var response: URLResponse? {
        get { return _response }
        set { _response = newValue }
    }
    
    override var countOfBytesExpectedToSend: Int64 {
        return 0
    }
    
    override var countOfBytesExpectedToReceive: Int64 {
        return NSURLSessionTransferSizeUnknown
    }
    
    // MARK: - Lifecycle methods
    override func resume() {
        self.onResume(self)
    }
    
    override func cancel() {
        pthread_mutex_lock(&mutex)
        // Cancel the task only if we haven't got a response yet and the task is running
        if (self._response == nil
            && (self._state == .running || self._state == .suspended)) {
            self._state = .canceling
            
            for mockedResponseItem in mockedResponseItems! {
                mockedResponseItem.cancel()
            }
            
            if let completionHandler = completionHandler {
                let urlResponse = HTTPURLResponse(url: (self.originalRequest?.url)!, statusCode: NSURLErrorCancelled, httpVersion: "HTTP/1.1", headerFields: [:])!
                completionHandler(nil, urlResponse, NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil))
            }
            else {
                if let delegate = session?.delegate as? URLSessionDataDelegate {
                    delegate.urlSession?(self.session!, task: self, didCompleteWithError: NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil))
                }
            }
            
        }
        pthread_mutex_unlock(&mutex)
    }
    
    deinit {
        self.cancel()
        pthread_mutex_destroy(&self.mutex)
    }
    
    // MARK: - Handling SUCCESS responses
    func scheduleMockedSuccessResponse(with request: URLRequest, session: URLSession, delay: Double, statusCode: Int, headers: [String:String], body: Data?, completionHandler : ((Data?, URLResponse?, Error?) -> Void)?) {
        
        var dispatchWorkItems: [DispatchWorkItem] = []
        
        if let completionHandler = completionHandler { // if we have a completion handler set, respond to it
            let dispatchWorkItemForCompletionHandler = createDispatchWorkItemForSuccessCompletionHandler(with: request, session: session, delay: delay, statusCode: statusCode, headers: headers, body: body, completionHandler: completionHandler)
            dispatchWorkItems.append(dispatchWorkItemForCompletionHandler)
        }
        else { // if the completion handler is not set, respond to the session delegate
            let dispatchWorkItemsForSessionDelegate = createSuccesssDispatchWorkItemsToRespondForSessionDelegate(with: request, session: session, delay: delay, statusCode: statusCode, headers: headers, body: body)
            dispatchWorkItems.append(contentsOf: dispatchWorkItemsForSessionDelegate)
        }
        
        self.completionHandler = completionHandler;
        self._originalRequest = request
        self.session = session
        self._state = .running
        
        schedule(mockedResponses: dispatchWorkItems, after: delay)
    }
    
    // MARK: - Handling ERROR responses
    func scheduleMockedErrorResponses(with request: URLRequest, session: URLSession, delay: Double, error: NSError, completionHandler : ((Data?, URLResponse?, Error?) -> Void)?) {
        
        var dispatchWorkItems : [DispatchWorkItem] = [];
        
        if let completionHandler = completionHandler { // if we have a completion handler set, respond to it
            let dispatchWorkItemForErrorCompletionHandler = createDispatchWorkItemForErrorCompletionHandler(with: request, session: session, delay: delay, error: error, completionHandler: completionHandler)
            dispatchWorkItems.append(dispatchWorkItemForErrorCompletionHandler)
        }
        else { // if the completion handler is not set, respond to the session delegate
            let dispatchWorkerItemForSessionDelegate = createErrorDispatchWorkItemToRespondForSessionDelegate(with: request, session: session, delay: delay, error: error)
            dispatchWorkItems.append(dispatchWorkerItemForSessionDelegate)
        }
        
        self.completionHandler = completionHandler;
        self._originalRequest = request
        self.session = session
        self._state = .running
        
        schedule(mockedResponses: dispatchWorkItems, after: delay)
    }
    
    // MARK: - Schedulling responses to run
    private func schedule(mockedResponses: [DispatchWorkItem], after: Double) {
        let timeDelta = 0.02
        var time = after
        
        pthread_mutex_lock(&mutex)
        
        //cancel previous responses if any
        if let mockedResponseItems = self.mockedResponseItems {
            for mockedResponseItem in mockedResponseItems {
                mockedResponseItem.cancel()
            }
        }
        
        self.mockedResponseItems = mockedResponses
        
        for mockedResponseItem in mockedResponses {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time,
                                          execute: mockedResponseItem)
            time += timeDelta
        }
        
        pthread_mutex_unlock(&mutex)
    }
    
}

// MARK: - SUCCESS Response Helpers
private extension MockSessionDataTask {
    
    func createDispatchWorkItemForSuccessCompletionHandler(with request: URLRequest, session: URLSession, delay: Double, statusCode: Int, headers: [String:String], body: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DispatchWorkItem {
        return DispatchWorkItem { [weak self] in
            guard let task = self else { return }
            pthread_mutex_lock(&task.mutex)
            if (task._state == .running
                || task._state == .suspended) {
                let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: headers)!
                task.response = response
                task._state = .completed
                completionHandler(body, response, nil)
            }
            pthread_mutex_unlock(&task.mutex)
        }
    }
    
    func createSuccesssDispatchWorkItemsToRespondForSessionDelegate(with request: URLRequest, session: URLSession, delay: Double, statusCode: Int, headers: [String:String], body: Data?) -> [DispatchWorkItem] {
        
        var dispatchWorkItemsForSessionDelegate = [DispatchWorkItem]()
        
        let didReceiveResponseWorkItem = DispatchWorkItem { [weak self] in
            guard let task = self else { return }
            guard let urlSessionDelegate: URLSessionDataDelegate = task.session?.delegate as? URLSessionDataDelegate else { return }
            pthread_mutex_lock(&task.mutex)
            if (task._state == .running
                || task._state == .suspended) {
                let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: headers)!
                task.response = response
                urlSessionDelegate.urlSession?(session, dataTask: task, didReceive: response) { _ in }
            }
            pthread_mutex_unlock(&task.mutex)
        }
        dispatchWorkItemsForSessionDelegate.append(didReceiveResponseWorkItem)
        
        if let body = body {
            let didReceiveBodyWorkItem = DispatchWorkItem { [weak self] in
                guard let task = self else { return }
                guard let urlSessionDelegate: URLSessionDataDelegate = task.session?.delegate as? URLSessionDataDelegate else { return }
                pthread_mutex_lock(&task.mutex)
                if (task._state == .running
                    || task._state == .suspended) {
                    urlSessionDelegate.urlSession?(session, dataTask: task, didReceive: body)
                }
                pthread_mutex_unlock(&task.mutex)
            }
            dispatchWorkItemsForSessionDelegate.append(didReceiveBodyWorkItem)
        }
        
        let didCompleteWithErrorWorkItem = DispatchWorkItem { [weak self] in
            guard let task = self else { return }
            guard let urlSessionDelegate: URLSessionDataDelegate = task.session?.delegate as? URLSessionDataDelegate else { return }
            pthread_mutex_lock(&task.mutex)
            if (task._state == .running
                || task._state == .suspended) {
                task._state = .completed
                urlSessionDelegate.urlSession?(session, task: task, didCompleteWithError: nil)
            }
            pthread_mutex_unlock(&task.mutex)
        }
        dispatchWorkItemsForSessionDelegate.append(didCompleteWithErrorWorkItem)
        
        return dispatchWorkItemsForSessionDelegate
    }
    
}

// MARK: - ERROR Response Helpers
private extension MockSessionDataTask {
    
    func createDispatchWorkItemForErrorCompletionHandler(with request: URLRequest, session: URLSession, delay: Double, error: NSError, completionHandler : @escaping ((Data?, URLResponse?, Error?) -> Void)) -> DispatchWorkItem
    {
        return DispatchWorkItem { [weak self] in
            guard let task = self else { return }
            pthread_mutex_lock(&task.mutex)
            if (task._state == .running
                || task._state == .suspended) {
                task._state = .completed
                let urlResponse = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: "HTTP/1.1", headerFields: [:])!
                completionHandler(nil, urlResponse, error)
            }
            pthread_mutex_unlock(&task.mutex)
        }
    }

    func createErrorDispatchWorkItemToRespondForSessionDelegate(with request: URLRequest, session: URLSession, delay: Double, error: NSError) -> DispatchWorkItem {
        return DispatchWorkItem { [weak self] in
            guard let task = self else { return }
            guard let urlSessionDelegate : URLSessionTaskDelegate = task.session?.delegate as? URLSessionTaskDelegate else { return }
            pthread_mutex_lock(&task.mutex)
            if (task._state == .running
                || task._state == .suspended) {
                task._state = .completed
                urlSessionDelegate.urlSession?(session, task: task, didCompleteWithError: error)
            }
            pthread_mutex_unlock(&task.mutex)
        }
    }
    
    
}
