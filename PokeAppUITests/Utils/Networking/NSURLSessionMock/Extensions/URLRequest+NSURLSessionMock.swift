//
//  URLRequest+NSURLSessionMock.swift
//  PokeAppUITests
//
//  Created by Eduardo Sanches Bocato on 05/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

extension URLRequest {
    
    internal func isMockableWith(other: URLRequest) -> Bool {
        return (self.url == other.url &&
            self.httpMethod == other.httpMethod)
    }
    
    var debugMockDescription: String {
        let method = self.httpMethod ?? "<no method>"
        let URL = self.url?.absoluteString ?? "<no url>"
        return "<NSURLRequest \(method) \(URL)"
    }
    
}
