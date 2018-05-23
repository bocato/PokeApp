//
//  EncodableExtension.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

extension Encodable {
    
    var dictionaryValue: [String: Any]? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            return nil
        }
        
        do {
            let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return jsonDictionary as? [String: Any]
        } catch {
            return nil
        }
    }
    
}
