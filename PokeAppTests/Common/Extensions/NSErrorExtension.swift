//
//  NSErrorExtension.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 07/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

extension NSError {

    class func buildMockError(domain: String = "PokeAppTests", code: Int = -9999, description: String = "Mocked error.") -> NSError {
        return NSError(domain: domain, code: code, userInfo: [kCFErrorLocalizedDescriptionKey as String: description])
    }
    
}
