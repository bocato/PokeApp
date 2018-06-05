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

protocol NetworkDispatcherProtocol {
    var url: URL { get }
    init(url: URL)
    func response<T: Codable>(of type: T.Type, from path: String?, method: HTTPMethod, payload: Data?, headers: [String: String]?) -> Observable<T?>
    func response<T: Codable>(of type: T.Type, from path: String?, method: HTTPMethod, payload: Data?, headers: [String: String]?) -> Observable<[T]?>
    func response(from path: String?, method: HTTPMethod, payload: Data?, headers: [String: String]?) -> Observable<Void>
}

class NetworkDispatcher: NetworkDispatcherProtocol {
    
    // MARK: - Properties
    private(set) var url: URL
    var defaultHeaders: [String: String] = [
        "content-type": "application/json"
    ]
    
    // MARK: - Initializers
    required init(url: URL) {
        self.url = url
    }
    
    // MARK: NetworkDispatcherProtocol
    /// Use this method to serialize object payload
    func response<T>(of type: T.Type, from path: String?, method: HTTPMethod, payload: Data?, headers: [String : String]?) -> Observable<T?> where T : Decodable, T : Encodable {
        
        
        return Observable.create { observable in
            
            guard let request = self.buildURLRequest(httpMethod: method, url: self.url, path: path, payload: payload, headers: headers) else {
                observable.onError(ErrorFactory.buildNetworkError(with: .invalidURL))
                return Disposables.create()
            }
            
            let task = self.dispatch(urlRequest: request, onCompleted: { (networkResponse) in
                
                if let networkError = networkResponse.error {
                    observable.onError(networkError)
                } else {
                    if let data = networkResponse.rawData {
                        do {
                            let serializedObject = try JSONDecoder().decode(T.self, from: data)
                            observable.onNext(serializedObject)
                        } catch let serializationError {
                            debugPrint("*** serializationError ***")
                            debugPrint(serializationError)
                            observable.onError(ErrorFactory.buildNetworkError(with: .serializationError))
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
                observable.onError(ErrorFactory.buildNetworkError(with: .invalidURL))
                return Disposables.create()
            }
            
            let task = self.dispatch(urlRequest: request, onCompleted: { (networkResponse) in
                
                if let networkError = networkResponse.error {
                    observable.onError(networkError)
                } else {
                    if let data = networkResponse.rawData {
                        do {
                            let serializedObject = try JSONDecoder().decode([T].self, from: data)
                            observable.onNext(serializedObject)
                        } catch let serializationError {
                            debugPrint("*** serializationError ***")
                            debugPrint(serializationError)
                            observable.onError(ErrorFactory.buildNetworkError(with: .serializationError))
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
                observable.onError(ErrorFactory.buildNetworkError(with: .invalidURL))
                return Disposables.create()
            }
            
            let task = self.dispatch(urlRequest: request, onCompleted: { (networkResponse) in
                
                if let networkError = networkResponse.error {
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
    
    private func dispatch(urlRequest: URLRequest!, onCompleted completion: @escaping (NetworkResponse) -> Void) -> URLSessionDataTask {
        
        var networkResponse = NetworkResponse()
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            networkResponse.response = response as? HTTPURLResponse
            networkResponse.request = urlRequest
            networkResponse.rawData = data
            
            if let data = data {
                networkResponse.rawResponse = String(data: data, encoding: .utf8)
            }
            
            guard let statusCode = networkResponse.response?.statusCode else {
                self.setUnknowErrorFor(networkResponse: &networkResponse, error: error)
                completion(networkResponse)
                return
            }
            
            if !(200...299 ~= statusCode) {
                self.mapErrors(statusCode: statusCode, error: error, networkResponse: &networkResponse)
            }
            
            completion(networkResponse)
            
        }
        
        networkResponse.task = task
        
        task.resume()
        
        return task
    }
    
}

// MARK: - Error Handlers
private extension NetworkDispatcher {
    
    private func setUnknowErrorFor(networkResponse: inout NetworkResponse, error: Error?) {
        if let error = error, error.isNetworkConnectionError {
            networkResponse.error = ErrorFactory.buildNetworkError(with: .unexpected)
            return
        }
        networkResponse.error = ErrorFactory.buildNetworkError(with: .unknown)
    }
    
    private func mapErrors(statusCode: Int, error: Error?, networkResponse: inout NetworkResponse) {
        
        guard error == nil else {
            setUnknowErrorFor(networkResponse: &networkResponse, error: error)
            return
        }
        
        guard 400...499 ~= statusCode, let data = networkResponse.rawData, let jsonString = String(data: data, encoding: .utf8),
            let serializedValue = try? JSONDecoder().decode(NetworkError.self, from: data) else {
                setUnknowErrorFor(networkResponse: &networkResponse, error: error)
                return
        }
        
        networkResponse.rawResponse = jsonString
        
        if serializedValue.message == nil {
            setUnknowErrorFor(networkResponse: &networkResponse, error: error)
        } else {
            networkResponse.error = serializedValue
        }
    }
    
}
