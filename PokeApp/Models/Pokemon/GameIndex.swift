//
//  GameIndex.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 18/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

struct GameIndex: Codable {
    
    let gameIndex: Int?
    let version: Form?
    
    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version
    }
    
}
