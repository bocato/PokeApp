//
//  SimpleFavoritesManager.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//


// TODO: Delete this when CoreData is implemented
import Foundation

class SimpleFavoritesManager: FavoritesManager {
    
    // MARK: Singleton
    static let shared = SimpleFavoritesManager()
    
    // MARK: - Properties
    internal(set) var favorites = [Pokemon]()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Helpers
    func add(pokemon: Pokemon) {
        guard let id = pokemon.id, favorites.filter( { $0.id == id } ).first == nil else {
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
        guard let id = pokemon.id, let _ = favorites.filter( { $0.id == id } ).first else {
            return false
        }
        return true
    }
    
}
