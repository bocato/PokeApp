//
//  NetworkError.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

struct NetworkError: Error {
    
    // MARK: - Properties
    var rawError: Error?
    var rawErrorString: String?
    var rawErrorData: Data?
    var requestError: SerializedNetworkError?
    
    var response: HTTPURLResponse?
    var request: URLRequest?
    var task: URLSessionDataTask?
    
    init(){}
    
    init(requestError: SerializedNetworkError) {
        self.requestError = requestError
    }
    
    init(rawError: Error?, rawErrorData: Data?, response: HTTPURLResponse?, request: URLRequest?) {
        self.rawError = rawError
        self.rawErrorData = rawErrorData
        self.response = response
        self.request = request
    }
    
    init(rawError: Error?, rawErrorData: Data?, requestError: SerializedNetworkError?, response: HTTPURLResponse?, request: URLRequest?) {
        self.rawError = rawError
        self.rawErrorData = rawErrorData
        self.requestError = requestError
        self.response = response
        self.request = request
    }
    
}

struct SerializedNetworkError: Codable {
    
    // MARK: - Properties
    var message: String?
    var code: Int?

}
