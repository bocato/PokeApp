//
//  NetworkDispatcher.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

protocol NetworkDispatcherProtocol {
    var url: URL { get }
    var session: URLSessionProtocol { get }
    init(url: URL, session: URLSessionProtocol)
    func response<T: Codable>(of type: T.Type, from path: String?, method: HTTPMethod, payload: Data?, headers: [String: String]?) -> Observable<T?>
    func response<T: Codable>(of type: T.Type, from path: String?, method: HTTPMethod, payload: Data?, headers: [String: String]?) -> Observable<[T]?>
    func response(from path: String?, method: HTTPMethod, payload: Data?, headers: [String: String]?) -> Observable<Void>
}

// MARK: URLSessionDataTaskProtocol
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

// MARK: - URLSessionProtocol
extension URLSession: URLSessionProtocol {
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        let urlRequest = request as URLRequest
        let task = dataTask(with: urlRequest, completionHandler: completionHandler)
        return task as URLSessionDataTaskProtocol
    }
}

class NetworkDispatcher: NetworkDispatcherProtocol {
    
    // MARK: - Properties
    private(set) var url: URL
    private(set) var session: URLSessionProtocol
    var defaultHeaders: [String: String] = [
        "content-type": "application/json"
    ]
    
    // MARK: - Initializers
    required init(url: URL, session: URLSessionProtocol = URLSession.shared) {
        self.url = url
        self.session = session
    }
    
    // MARK: NetworkDispatcherProtocol
    /// Use this method to serialize object payload
    func response<T>(of type: T.Type, from path: String?, method: HTTPMethod, payload: Data?, headers: [String : String]?) -> Observable<T?> where T : Decodable, T : Encodable {
        
        return Observable.create { observable in
            
            guard let request = self.buildURLRequest(httpMethod: method, url: self.url, path: path, payload: payload, headers: headers) else {
                let networkError = NetworkError(requestError: ErrorFactory.buildNetworkError(with: .invalidURL))
                observable.onError(networkError)
                return Disposables.create()
            }
            
            let task = self.dispatch(urlRequest: request, onCompleted: { (networkResponse, networkError) in
                
                if let networkError = networkError {
                    observable.onError(networkError)
                } else {
                    if let data = networkResponse.rawData {
                        do {
                            let serializedObject = try JSONDecoder().decode(T.self, from: data)
                            observable.onNext(serializedObject)
                        } catch let serializationError {
                            debugPrint("[NetworkDispatcher] " + "*** serializationError ***")
                            debugPrint("[NetworkDispatcher] " + serializationError.localizedDescription)
                            let requestError = ErrorFactory.buildNetworkError(with: .serializationError)
                            let networkErrorForSerialization = NetworkError(networkResponse: networkResponse, rawError: serializationError, requestError: requestError)
                            observable.onError(networkErrorForSerialization)
                        }
                    } else {
                        observable.onNext(nil)
                    }
                }
                
                observable.onCompleted()
                
            })
            
            return Disposables.create {
                task.cancel()
            }
            
        }
        
    }
    
    /// Use this method to serialize array payload
    func response<T>(of type: T.Type, from path: String?, method: HTTPMethod, payload: Data?, headers: [String : String]?) -> Observable<[T]?> where T : Decodable, T : Encodable {
        
        return Observable.create { observable in
            
            guard let request = self.buildURLRequest(httpMethod: method, url: self.url, path: path, payload: payload, headers: headers) else {
                let networkError = NetworkError(requestError: ErrorFactory.buildNetworkError(with: .invalidURL))
                observable.onError(networkError)
                return Disposables.create()
            }
            
            let task = self.dispatch(urlRequest: request, onCompleted: { (networkResponse, networkError) in
                
                if let networkError = networkError {
                    observable.onError(networkError)
                } else {
                    if let data = networkResponse.rawData {
                        do {
                            let serializedObject = try JSONDecoder().decode([T].self, from: data)
                            observable.onNext(serializedObject)
                        } catch let serializationError {
                            debugPrint("[NetworkDispatcher] " + "*** serializationError ***")
                            debugPrint("[NetworkDispatcher] " + serializationError.localizedDescription)
                            let requestError = ErrorFactory.buildNetworkError(with: .serializationError)
                            let networkErrorForSerialization = NetworkError(networkResponse: networkResponse, rawError: serializationError, requestError: requestError)
                            observable.onError(networkErrorForSerialization)
                        }
                    } else {
                        observable.onNext(nil)
                    }
                }
                
                observable.onCompleted()
                
            })
            
            return Disposables.create {
                task.cancel()
            }
            
        }
        
    }
    
    /// Use this method when there is no need to serialize service payload
    func response(from path: String?, method: HTTPMethod, payload: Data?, headers: [String : String]?) -> Observable<Void> {
        
        return Observable.create { observable in
            
            guard let request = self.buildURLRequest(httpMethod: method, url: self.url, path: path, payload: payload, headers: headers) else {
                let networkError = NetworkError(requestError: ErrorFactory.buildNetworkError(with: .invalidURL))
                observable.onError(networkError)
                return Disposables.create()
            }
            
            let task = self.dispatch(urlRequest: request, onCompleted: { (_, networkError) in
                
                if let networkError = networkError {
                    observable.onError(networkError)
                } else {
                    observable.onNext(())
                }
                
                observable.onCompleted()
                
            })
            
            return Disposables.create {
                task.cancel()
            }
            
        }
        
    }
    
}

// MARK: - URL Request
private extension NetworkDispatcher {
    
    // MARK: - Helper Methods
    private func buildURLRequest(httpMethod: HTTPMethod, url: URL, path: String?, payload: Data? = nil, headers: [String:String]? = nil) -> URLRequest? {
    
        var requestURL = url
        if let path = path {
            let fullURL = self.getURL(with: path)
            
            guard let uri = fullURL else {
                return nil
            }
            
            requestURL = uri
        }
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = defaultHeaders
        request.httpBody = payload
        
        guard let headers = headers else {
            return request
        }
        
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
    
    private func getURL(with path: String) -> URL? {
        guard let urlString = url.appendingPathComponent(path).absoluteString.removingPercentEncoding,
            let requestUrl = URL(string: urlString) else {
                return nil
        }
        return requestUrl
    }
    
}

// MARK: - Request Dispatcher
private extension NetworkDispatcher {
    
    private func dispatch(urlRequest: URLRequest, onCompleted completion: @escaping (NetworkResponse, NetworkError?) -> Void) -> URLSessionDataTaskProtocol {
        
        var networkResponse = NetworkResponse()
        var networkError: NetworkError?
        
        let nsURLRequest = urlRequest as NSURLRequest
        
        let task = session.dataTask(with: nsURLRequest) { data, response, error in
            
            networkResponse.response = response as? HTTPURLResponse
            networkResponse.request = urlRequest
            networkResponse.rawData = data
            
            if let data = data {
                networkResponse.rawResponse = String(data: data, encoding: .utf8)
            }
            
            guard let statusCode = networkResponse.response?.statusCode else {
                networkError = NetworkError(rawError: error, rawErrorData: data, response: response as? HTTPURLResponse, request: urlRequest)
                self.setUnknowErrorFor(networkError: &networkError)
                completion(networkResponse, networkError)
                return
            }
            
            if !(200...299 ~= statusCode) {
                networkError = NetworkError(rawError: error, rawErrorData: data, response: response as? HTTPURLResponse, request: urlRequest)
                self.mapErrors(statusCode: statusCode, error: error, networkError: &networkError)
            }
            
            completion(networkResponse, networkError)
            
        }
        
        networkResponse.task = task
        networkError?.task = task
        
        task.resume()
        
        return task
    }
    
}

// MARK: - Error Handlers
private extension NetworkDispatcher {
    
    private func setUnknowErrorFor(networkError: inout NetworkError?) {
        if let error = networkError?.rawError, error.isNetworkConnectionError {
            networkError?.requestError = ErrorFactory.buildNetworkError(with: .connectivity)
            return
        }
        networkError?.requestError = ErrorFactory.buildNetworkError(with: .unexpected)
    }
    
    private func mapErrors(statusCode: Int, error: Error?, networkError: inout NetworkError?) {
        
        guard error == nil else {
            setUnknowErrorFor(networkError: &networkError)
            return
        }
        
        guard 400...499 ~= statusCode, let data = networkError?.rawErrorData, let jsonString = String(data: data, encoding: .utf8),
            let serializedValue = try? JSONDecoder().decode(SerializedNetworkError.self, from: data) else {
                setUnknowErrorFor(networkError: &networkError)
                return
        }
        
        networkError?.rawErrorString = jsonString // deletar? realmente preciso?
        
        if serializedValue.message == nil {
            setUnknowErrorFor(networkError: &networkError)
        } else {
            networkError?.requestError = serializedValue
        }
    }
    
}
