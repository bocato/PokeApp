//
//  ServiceResponse.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

struct NetworkResponse {
    
    // MARK: - Properties
    var rawData: Data?
    var rawResponse: String?
    
    var response: HTTPURLResponse?
    var request: URLRequest?
    var task: URLSessionDataTaskProtocol?
    
}
