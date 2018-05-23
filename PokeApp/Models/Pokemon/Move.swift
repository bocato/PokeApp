//
//  Move.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 18/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

struct Move: Codable {
    
    var move: Form?
    var versionGroupDetails: [VersionGroupDetail]?
    
    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
    
}
