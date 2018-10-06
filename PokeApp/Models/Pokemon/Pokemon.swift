//
//  Pokemon.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 18/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    
    let id: Int?
    let name: String?
    let baseExperience, height: Int?
    let isDefault: Bool?
    let order, weight: Int?
    let abilities: [Ability]?
    let forms: [Form]?
    let gameIndices: [GameIndex]?
    let moves: [Move]?
    let species: Form?
    let stats: [Stat]?
    let types: [TypeElement]?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case baseExperience = "base_experience"
        case height
        case isDefault = "is_default"
        case order, weight, abilities, forms
        case gameIndices = "game_indices"
        case moves, species, stats, types
    }
    
}

extension Pokemon {
    
    var imageURL: String? {
        guard let id = id, let spritesURL = Environment.shared.spritesURL else { return nil }
        return "\(spritesURL)\("pokemon/")\(id).png"
    }
    
}
