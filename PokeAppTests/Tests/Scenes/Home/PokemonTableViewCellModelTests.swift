//
//  PokemonTableViewCellModelTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 07/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class PokemonTableViewCellModelTests: XCTestCase {
    
    // MARK: - Tests
    func testValidPokemonName() {
        // Given
        let bulbassaur = PokemonListResult(url: "https://pokeapi.co/api/v2/pokemon/1/", name: "bulbasaur")
        
        // When
        let sut = PokemonTableViewCellModel(listItem: bulbassaur, imageDownloader: ImageDownloaderStub())
        
        // Then
        XCTAssertEqual(sut.pokemonName, "Bulbasaur")
    }
    
    func testInvalidPokemonName() {
        // Given
        let invalid = PokemonListResult(url: nil, name: nil)
        
        // When
        let sut = PokemonTableViewCellModel(listItem: invalid, imageDownloader: ImageDownloaderStub())
        
        // Then
        XCTAssertEqual(sut.pokemonName, "")
    }
    
    func testValidPokemonNumberString() {
        // Given
        let bulbassaur = PokemonListResult(url: "https://pokeapi.co/api/v2/pokemon/1/", name: "bulbasaur")
        let sut = PokemonTableViewCellModel(listItem: bulbassaur, imageDownloader: ImageDownloaderStub())
        
        // Then
        XCTAssertEqual(sut.pokemonNumberString, "#1: ")
    }
    
    func testInvalidPokemonNumberString() {
        // Given
        let invalid = PokemonListResult(url: nil, name: nil)
        let sut = PokemonTableViewCellModel(listItem: invalid, imageDownloader: ImageDownloaderStub())
        
        // Then
        XCTAssertEqual(sut.pokemonNumberString, "")
    }
    
    func testWithValidPokemon() {
        // Given
        let bulbassaur = PokemonListResult(url: "https://pokeapi.co/api/v2/pokemon/1/", name: "bulbasaur")
        let image = UIImage()
        let imageDownloader = ImageDownloaderStub(mockType: .image(image))
        
        // When
        let sut = PokemonTableViewCellModel(listItem: bulbassaur, imageDownloader: imageDownloader)
        let pokemonImageCollector = RxCollector<UIImage?>().collect(from: sut.pokemonImage.asObservable())
        
        // Then
        let collectedImage = pokemonImageCollector.items.last!
        XCTAssertNotNil(collectedImage, "Invalid result.")
        XCTAssertEqual(image, collectedImage)
    }
    
    func testWithInvalidPokemon() {
        // Given
        let invalid = PokemonListResult(url: nil, name: nil)
        
        // When
        let sut = PokemonTableViewCellModel(listItem: invalid, imageDownloader: ImageDownloaderStub())
        let pokemonImageCollector = RxCollector<UIImage?>().collect(from: sut.pokemonImage.asObservable())
        
        // Then
        let image = pokemonImageCollector.items.last!
        XCTAssertNil(image, "Invalid result.")
    }

}
