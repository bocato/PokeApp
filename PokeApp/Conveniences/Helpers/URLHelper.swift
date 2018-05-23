//
//  URLHelper.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

class URLHelper {
    
    static func escapedParameters(_ parameters: [String: Any]) -> String {
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            for (key, value) in parameters {
                // make sure that it is a string value
                let stringValue = "\(value)"
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
    // EXAMPLE: (URLHelper.urlStringWithQueryParameters("https", host: "api.flickr.com", path: "/services/rest", queryPrameters: ["api_key": "1234", "search": "purple"])
    static func urlStringWithQueryParameters(_ scheme: String = "https", host: String!, path: String = "", queryPrameters: [String: String]) -> String {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host // Ex: "api.flickr.com"
        components.path = path // Ex: "/services/rest"
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in queryPrameters {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        return components.url!.absoluteString
    }
    
}
