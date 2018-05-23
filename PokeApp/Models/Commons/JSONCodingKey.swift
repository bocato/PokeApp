//
//  JSONCodingKey.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 18/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

class JSONCodingKey: CodingKey {
    
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}
