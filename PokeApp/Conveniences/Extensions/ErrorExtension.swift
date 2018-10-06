//
//  ErrorExtension.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

extension Error {
    
    var networkErrors: [Int] {
        return [NSURLErrorCannotConnectToHost, NSURLErrorNetworkConnectionLost, NSURLErrorDNSLookupFailed, NSURLErrorResourceUnavailable,
                NSURLErrorNotConnectedToInternet, NSURLErrorBadServerResponse, NSURLErrorInternationalRoamingOff, NSURLErrorCallIsActive]
    }
    
    var isNetworkConnectionError: Bool {
        if (self as NSError).domain == NSURLErrorDomain && networkErrors.contains((self as NSError).code) {
            return true
        }
        return false
    }
    
}
