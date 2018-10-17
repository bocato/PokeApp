//
//  ErrorFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

class ErrorFactory {
    
    static func buildNetworkError(with code: NetworkErrorCode) -> SerializedNetworkError {
        switch code {
        case .unknown:
            return SerializedNetworkError(message: NetworkErrorMessage.unknown.rawValue, code: NetworkErrorCode.unknown.rawValue)
        case .unexpected:
            return SerializedNetworkError(message: NetworkErrorMessage.unexpected.rawValue, code: NetworkErrorCode.unexpected.rawValue)
        case .invalidURL:
            return SerializedNetworkError(message: NetworkErrorMessage.invalidURL.rawValue, code: NetworkErrorCode.invalidURL.rawValue)
        case .jsonParse:
            return SerializedNetworkError(message: NetworkErrorMessage.jsonParse.rawValue, code: NetworkErrorCode.jsonParse.rawValue)
        case .connectivity:
            return SerializedNetworkError(message: NetworkErrorMessage.connectivity.rawValue, code: NetworkErrorCode.connectivity.rawValue)
        default:
            return SerializedNetworkError(message: NetworkErrorMessage.unknown.rawValue, code: NetworkErrorCode.unknown.rawValue)
        }
    }
    
}
