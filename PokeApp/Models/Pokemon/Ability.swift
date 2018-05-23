//
//  Ability.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 18/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

struct Ability: Codable {
    
    var isHidden: Bool?
    var slot: Int?
    var ability: Form?
    
    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case slot, ability
    }
}
