//
//  Pokemon.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 18/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    
    var id: Int?
    var name: String?
    var baseExperience, height: Int?
    var isDefault: Bool?
    var order, weight: Int?
    var abilities: [Ability]?
    var forms: [Form]?
    var gameIndices: [GameIndex]?
    var moves: [Move]?
    var species: Form?
    var stats: [Stat]?
    var types: [TypeElement]?
    
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
        guard let id = id else { return nil }
        return "\(Environment.shared.spritesURL)\(id).png"
    }
    
}
