//
//  FavoriteCollectionViewCellModelTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 07/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class FavoriteCollectionViewCellModelTests: XCTestCase {

    func testValidPokemonName() {
        // Given
        guard let bulbassaur = try? JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur)) else {
            XCTFail("Could not prepare test case.")
            return
        }
        let sut = FavoriteCollectionViewCellModel(data: bulbassaur)
        
        // Then
        XCTAssertEqual(sut.pokemonName, "Bulbasaur")
    }
    
    func testInvalidPokemonName() {
        // Given
        let invalidPokemon = Pokemon(id: nil, name: nil, baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        let sut = FavoriteCollectionViewCellModel(data: invalidPokemon)
        
        // Then
        XCTAssertEqual(sut.pokemonName, "")
    }
    
    func testValidPokemonNumberString() {
        // Given
        guard let bulbassaur = try? JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur)) else {
            XCTFail("Could not prepare test case.")
            return
        }
        let sut = FavoriteCollectionViewCellModel(data: bulbassaur)
        
        // Then
        XCTAssertEqual(sut.pokemonNumberString, "#1: ")
    }
    
    func testInvalidPokemonNumberString() {
        // Given
        let invalidPokemon = Pokemon(id: nil, name: "Missigno", baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        let sut = FavoriteCollectionViewCellModel(data: invalidPokemon)
        
        // Then
        XCTAssertEqual(sut.pokemonNumberString, "")
    }

}
