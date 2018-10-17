//
//  MockDataHelper.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 06/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

class MockDataHelper {
    
    // MARK: Enums
    enum MockedResource: String {
        case bulbassaur
        case pokemonList
    }
    
    // MARK: Helpers
    static func getData(forResource resource: MockedResource) -> Data {
        
        let bundle = Bundle(for: self)
        guard let path = bundle.path(forResource: resource.rawValue, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                fatalError("Resource not found!")
        }
        
        return data
    }
    
}
