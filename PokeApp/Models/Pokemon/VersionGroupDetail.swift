//
//  VersionGroupDetail.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 18/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

struct VersionGroupDetail: Codable {
    
    let levelLearnedAt: Int?
    let versionGroup: Form?
    let moveLearnMethod: Form?
    
    enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case versionGroup = "version_group"
        case moveLearnMethod = "move_learn_method"
    }
    
}
