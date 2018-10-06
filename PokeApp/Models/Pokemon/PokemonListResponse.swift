//
//  PokemonListResponse.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 15/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

struct PokemonListResponse: Codable {
    
    let count: Int?
    let previous: String?
    let results: [PokemonListResult]?
    let next: String?
    
}
