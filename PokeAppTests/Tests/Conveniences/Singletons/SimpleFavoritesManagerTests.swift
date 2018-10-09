//
//  SimpleFavoritesManagerTests.swift
//  PokeAppTests
//
//  Created by Eduardo Bocato on 08/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class SimpleFavoritesManagerTests: XCTestCase {

    let sut = SimpleFavoritesManager.shared
    
    override func tearDown() {
        super.tearDown()
        sut.favorites.removeAll()
    }
    
    // MARK: - Tests
    func testAddValidPokemon() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        
        // When
        sut.add(pokemon: bulbassaur)
        
        // Then
        let containsBulbassaur = sut.favorites.contains(where: { $0.id == bulbassaur.id })
        XCTAssertTrue(containsBulbassaur)
    }
    
    func testAddInvalidPokemon() {
        // Given
        let invalidPokemon = Pokemon(id: nil, name: "Missigno", baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        
        // When
        sut.add(pokemon: invalidPokemon)
        
        // Then
        let containsInvalidPokemon = sut.favorites.contains(where: { $0.id == invalidPokemon.id })
        XCTAssertFalse(containsInvalidPokemon)
        
    }
    
    func testAddDuplicatedValidPokemon() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        let bulbassaur2 = Pokemon(id: bulbassaur.id, name: "Bulbassaur 2", baseExperience: bulbassaur.baseExperience, height: bulbassaur.height, isDefault: bulbassaur.isDefault, order: bulbassaur.order, weight: bulbassaur.weight, abilities: bulbassaur.abilities, forms: bulbassaur.forms, gameIndices: bulbassaur.gameIndices, moves: bulbassaur.moves, species: bulbassaur.species, stats: bulbassaur.stats, types: bulbassaur.types)
        
        // When
        sut.add(pokemon: bulbassaur)
        sut.add(pokemon: bulbassaur2)
        
        // Then
        let containsBulbassaur2 = sut.favorites.contains(where: { $0.name == bulbassaur2.name })
        XCTAssertFalse(containsBulbassaur2)
    }
    
    func testRemoveInvalidPokemon() {
        // Given
        let invalidPokemon = Pokemon(id: nil, name: "Missigno", baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        
        // When
        sut.remove(pokemon: invalidPokemon)
        
        // Then
        let containsInvalidPokemon = sut.favorites.contains(where: { $0.id == invalidPokemon.id })
        XCTAssertFalse(containsInvalidPokemon)
    }
    
    func testRemoveExistentValidPokemon() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        sut.add(pokemon: bulbassaur)
        
        // When
        sut.remove(pokemon: bulbassaur)
        
        // Then
        let containsBulbassaur = sut.favorites.contains(where: { $0.id == bulbassaur.id })
        XCTAssertFalse(containsBulbassaur)
    }
    
    func testRemoveUnexistentValidPokemon() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        
        // When
        sut.remove(pokemon: bulbassaur)
        
        // Then
        let containsBulbassaur = sut.favorites.contains(where: { $0.id == bulbassaur.id })
        XCTAssertFalse(containsBulbassaur)
    }
    
    func testIsFavoriteForExistentValidPokemon() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        sut.add(pokemon: bulbassaur)
        
        // When
        let isFavorite = sut.isFavorite(pokemon: bulbassaur)
        
        // Then
        XCTAssertTrue(isFavorite)
    }
    
    func testIsFavoriteForUnexistentValidPokemon() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        
        // When
        let isFavorite = sut.isFavorite(pokemon: bulbassaur)
        
        // Then
        XCTAssertFalse(isFavorite)
    }
    
    func testIsFavoriteForInvalidPokemon() {
        // Given
        let invalidPokemon = Pokemon(id: nil, name: "Missigno", baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        
        // When
        let isFavorite = sut.isFavorite(pokemon: invalidPokemon)
        
        // Then
        XCTAssertFalse(isFavorite)
    }

}
