//
//  ServiceError.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

struct NetworkError: Codable, Error {
    
    // MARK: - Properties
    var message: String?
    var code: Int?
    
}
