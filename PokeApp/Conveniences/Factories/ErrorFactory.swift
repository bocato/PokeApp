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
    
    static func buildPersistenceError(with code: PersistenceErrorCode) -> PersistenceError {
        switch code {
        case .unknown:
            return PersistenceError(message: PersistenceErrorMessage.unknown.rawValue, code: PersistenceErrorCode.unknown.rawValue)
        case .unexpected:
            return PersistenceError(message: PersistenceErrorMessage.unexpected.rawValue, code: PersistenceErrorCode.unexpected.rawValue)
        case .notFound:
            return PersistenceError(message: PersistenceErrorMessage.notFound.rawValue, code: PersistenceErrorCode.notFound.rawValue)
        }
    }
    
    static func buildPersistenceError(with error: Error!) -> PersistenceError {
        let message = (error as NSError).description
        let code = (error as NSError).code
        return PersistenceError(message: message, code: code)
    }
    
}

