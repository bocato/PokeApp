//
//  Stat.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 18/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

struct Stat: Codable {
    
    var baseStat: Int?
    var effort: Int?
    var stat: Form?
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
    
}
