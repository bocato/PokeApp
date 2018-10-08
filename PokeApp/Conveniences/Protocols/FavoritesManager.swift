//
//  FavoritesManager.swift
//  PokeApp
//
//  Created by Eduardo Bocato on 08/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

protocol FavoritesManager {
    // MARK: - Properties
    var favorites: [Pokemon] { get set }
    
    // MARK: - Functions
    func add(pokemon: Pokemon)
    func remove(pokemon: Pokemon)
    func isFavorite(pokemon: Pokemon) -> Bool
}
