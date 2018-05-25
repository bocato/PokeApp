//
//  ErrorFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

class ErrorFactory {
    
    static func buildNetworkError(with code: NetworkErrorCode!) -> NetworkError {
        switch code {
        case .unknown:
            return NetworkError(message: NetworkErrorMessage.unknown.rawValue, code: NetworkErrorCode.unknown.rawValue)
        case .unexpected:
            return NetworkError(message: NetworkErrorMessage.unexpected.rawValue, code: NetworkErrorCode.unexpected.rawValue)
        case .invalidURL:
            return NetworkError(message: NetworkErrorMessage.invalidURL.rawValue, code: NetworkErrorCode.invalidURL.rawValue)
        default:
            return NetworkError(message: NetworkErrorMessage.unknown.rawValue, code: NetworkErrorCode.unknown.rawValue)
        }
    }
    
}

