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
    
    // MARK: - Tests
    func testValidPokemonName() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        
        // When
        let sut = FavoriteCollectionViewCellModel(data: bulbassaur, imageDownloader: ImageDownloaderStub())
        
        // Then
        XCTAssertEqual(sut.pokemonName, "Bulbasaur")
    }
    
    func testInvalidPokemonName() {
        // Given
        let invalidPokemon = Pokemon(id: nil, name: nil, baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        
        // When
        let sut = FavoriteCollectionViewCellModel(data: invalidPokemon, imageDownloader: ImageDownloaderStub())
        
        // Then
        XCTAssertEqual(sut.pokemonName, "")
    }
    
    func testValidPokemonNumberString() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        
        // When
        let sut = FavoriteCollectionViewCellModel(data: bulbassaur, imageDownloader: ImageDownloaderStub())
        
        // Then
        XCTAssertEqual(sut.pokemonNumberString, "#1: ")
    }
    
    func testInvalidPokemonNumberString() {
        // Given
        let invalidPokemon = Pokemon(id: nil, name: "Missigno", baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        let sut = FavoriteCollectionViewCellModel(data: invalidPokemon, imageDownloader: ImageDownloaderStub())
        
        // Then
        XCTAssertEqual(sut.pokemonNumberString, "")
    }

    func testWithValidPokemon() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        let image = UIImage()
        let imageDownloader = ImageDownloaderStub(mockType: .image(image))
        
        // When
        let sut = FavoriteCollectionViewCellModel(data: bulbassaur, imageDownloader: imageDownloader)
        let pokemonImageCollector = RxCollector<UIImage?>().collect(from: sut.pokemonImage.asObservable())
        
        // Then
        let collectedImage = pokemonImageCollector.items.last!
        XCTAssertNotNil(collectedImage, "Invalid result.")
        XCTAssertEqual(image, collectedImage)
    }
    
    func testWithInvalidPokemon() {
        // Given
        let invalidPokemon = Pokemon(id: nil, name: "Missigno", baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        
        // When
        let sut = FavoriteCollectionViewCellModel(data: invalidPokemon, imageDownloader: ImageDownloaderStub())
        let pokemonImageCollector = RxCollector<UIImage?>().collect(from: sut.pokemonImage.asObservable())
        
        // Then
        // Then
        let image = pokemonImageCollector.items.last!
        XCTAssertNil(image, "Invalid result.")
    }
    
}
