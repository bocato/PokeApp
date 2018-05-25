//
//  FavoritesManager.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//


// TODO: Delete this when CoreData is implemented

import Foundation

class FavoritesManager {
    
    // MARK: - Singleton
    static let shared = FavoritesManager()
    
    // MARK: - Properties
    var favorites = [Pokemon]()
    
    // MARK: - Helpers
    func add(pokemon: Pokemon) {
        guard let id = pokemon.id, !favorites.contains(where: { $0.id == id }) else {
            return
        }
        favorites.append(pokemon)
    }
    
    func remove(pokemon: Pokemon) {
        guard let id = pokemon.id, let index = favorites.index(where: { $0.id ==  id }) else {
            return
        }
        favorites.remove(at: index)
    }
    
    func isFavorite(pokemon: Pokemon) -> Bool {
        guard let id = pokemon.id, favorites.contains(where: { $0.id == id }) else {
            return false
        }
        return true
    }
    
}
