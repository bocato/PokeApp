//
//  NetworkDispatcherStub.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 07/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import RxSwift
@testable import PokeApp

class NetworkDispatcherStub: NetworkDispatcherProtocol {
    
    // MARK: - Properties
    private(set) var url: URL
    
    // MARK: - Lifecycle
    required init(url: URL) {
        self.url = url
    }
    
    // MARK: - Mocked responses
    func response<T: Codable>(of type: T.Type, from path: String?, method: HTTPMethod, payload: Data?, headers: [String : String]?) -> Observable<[T]?> {
        
        return Observable.create { observable in
            
            guard var request = self.buildURLRequest(httpMethod: method, url: self.url, path: path, payload: payload, headers: headers) else {
                observable.onError(NetworkError(requestError: ErrorFactory.buildNetworkError(with: .invalidURL), request: nil))
                return Disposables.create()
            }
            
            request.httpMethod = method.rawValue
            request.httpBody = payload
            
            let networkErrorForSerialization = NetworkError(requestError: ErrorFactory.buildNetworkError(with: .jsonParse), request: request)
            observable.onError(networkErrorForSerialization)
            
            return Disposables.create()
        }
    }
    
    func response<T: Codable>(of type: T.Type, from path: String?, method: HTTPMethod, payload: Data?, headers: [String : String]?) -> Observable<T?> {
        
        return Observable.create { observable in
            
            guard var request = self.buildURLRequest(httpMethod: method, url: self.url, path: path, payload: payload, headers: headers) else {
                observable.onError(NetworkError(requestError: ErrorFactory.buildNetworkError(with: .invalidURL), request: nil))
                return Disposables.create()
            }
            
            request.httpMethod = method.rawValue
            request.httpBody = payload
            
            let networkErrorForSerialization = NetworkError(requestError: ErrorFactory.buildNetworkError(with: .jsonParse), request: request)
            observable.onError(networkErrorForSerialization)
            
            return Disposables.create()
        }
    }
    
    func response(from path: String?, method: HTTPMethod, payload: Data?, headers: [String : String]?) -> Observable<Void> {
        
        return Observable.create { observable in
            
            guard var request = self.buildURLRequest(httpMethod: method, url: self.url, path: path, payload: payload, headers: headers) else {
                observable.onError(NetworkError(requestError: ErrorFactory.buildNetworkError(with: .invalidURL), request: nil))
                return Disposables.create()
            }
            
            request.httpMethod = method.rawValue
            request.httpBody = payload
            
            let networkErrorForSerialization = NetworkError(requestError: ErrorFactory.buildNetworkError(with: .jsonParse), request: request)
            observable.onError(networkErrorForSerialization)
            
            return Disposables.create()
        }
    }
    
}

// MARK: - URL Request
private extension NetworkDispatcherStub {
    
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
        let defaultHeaders: [String: String] = [
            "content-type": "application/json"
        ]
        
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
