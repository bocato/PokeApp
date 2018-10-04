//
//  Storyboards.swift
//  PokeApp
//
//  Created by Eduardo Bocato on 04/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

enum Storyboards: String {
    
    // MARK: - Storyboard Names
    case tabBar = "TabBar"
    case home = "Home"
    case favorites = "Favorites"
    case details = "Details"
    
    // MARK: - Properties
    var name: String {
        return self.rawValue
    }
    
}
