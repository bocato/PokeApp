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

    // MARK: - Properties
    var imageDownloader: ImageDownloaderProtocol!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        imageDownloader = KingfisherImageDownloader() // TODO: Change this to the mock version
    }
    
    // MARK: - Tests
    func testValidPokemonName() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        let sut = FavoriteCollectionViewCellModel(data: bulbassaur, imageDownloader: imageDownloader)
        
        // Then
        XCTAssertEqual(sut.pokemonName, "Bulbasaur")
    }
    
    func testInvalidPokemonName() {
        // Given
        let invalidPokemon = Pokemon(id: nil, name: nil, baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        let sut = FavoriteCollectionViewCellModel(data: invalidPokemon, imageDownloader: imageDownloader)
        
        // Then
        XCTAssertEqual(sut.pokemonName, "")
    }
    
    func testValidPokemonNumberString() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        let sut = FavoriteCollectionViewCellModel(data: bulbassaur, imageDownloader: imageDownloader)
        
        // Then
        XCTAssertEqual(sut.pokemonNumberString, "#1: ")
    }
    
    func testInvalidPokemonNumberString() {
        // Given
        let invalidPokemon = Pokemon(id: nil, name: "Missigno", baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        let sut = FavoriteCollectionViewCellModel(data: invalidPokemon, imageDownloader: imageDownloader)
        
        // Then
        XCTAssertEqual(sut.pokemonNumberString, "")
    }

}
