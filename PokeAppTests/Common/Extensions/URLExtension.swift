//
//  URLExtension.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 20/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

extension URL {
    
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
    
    func contains(key: String) -> Bool {
        return self.absoluteString.contains(key)
    }
    
}
