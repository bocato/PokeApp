//
//  DefaultRequestMatcher.swift
//  PokeAppUITests
//
//  Created by Eduardo Sanches Bocato on 05/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

// MARK: Enums
enum MatchesResponse {
    case noMatch
    case matches(extractions:[String])
}

// MARK: - Protocols / Interfaces
protocol RequestMatcher {
    func matches(request: URLRequest) -> MatchesResponse
}

struct DefaultRequestMatcher: RequestMatcher {
    
    // MARK: - Properties
    let pathMatcher: NSRegularExpression
    let method: String
    
    // MARK: - Initalization
    init(url: URL, method: String) {
        let path = NSRegularExpression.escapedPattern(for: url.absoluteString)
        try! self.init(expression: "^\(path)$", method: method)
    }
    
    init(expression: String, method: String) throws {
        try pathMatcher = NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.anchorsMatchLines)
        self.method = method
    }
    
    // MARK: - Functions
    func matches(request: URLRequest) -> MatchesResponse {
        
        guard request.httpMethod == method else { return .noMatch }
        
        let path = request.url?.absoluteString ?? ""
        let range = NSMakeRange(0, path.utf16.count)
        let matches = pathMatcher.matches(in: path, options: [], range: range)
        guard matches.count > 0 else { return .noMatch }
        
        // If there were any matches, extract them here (match at index 0 is the whole string - skip that one)
        var extractions = [String]()
        for match in matches {
            for n in 1 ..< match.numberOfRanges {
                let range = match.range(at: n)
                let extraction = (path as NSString).substring(with: range)
                extractions.append(extraction)
            }
        }
        
        return .matches(extractions: extractions)
    }
}
