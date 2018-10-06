//
//  PokemonListResult.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 15/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

struct PokemonListResult: Codable {
    
    let url: String?
    let name: String?
    
}

extension PokemonListResult {
    
    var id: Int? {
        guard let url = url else { return nil }
        let cleanId = url.replacingOccurrences(of: Environment.shared.baseURL, with: "")
            .replacingOccurrences(of: "pokemon/", with: "")
            .replacingOccurrences(of: "/", with: "")
        return Int(cleanId)
    }
    
    var imageURL: String? {
        guard let id = id, let spritesURL = Environment.shared.spritesURL else { return nil }
        return "\(spritesURL)\("pokemon/")\(id).png"
    }
    
}

