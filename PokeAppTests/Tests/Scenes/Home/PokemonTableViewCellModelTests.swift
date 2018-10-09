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
        let bulbassaur = PokemonListResult(url: "https://pokeapi.co/api/v2/pokemon/1/", name: "bulbasaur")
        let sut = PokemonTableViewCellModel(listItem: bulbassaur, imageDownloader: imageDownloader)
        
        // Then
        XCTAssertEqual(sut.pokemonName, "Bulbasaur")
    }
    
    func testInvalidPokemonName() {
        // Given
        let invalid = PokemonListResult(url: nil, name: nil)
        let sut = PokemonTableViewCellModel(listItem: invalid, imageDownloader: imageDownloader)
        
        // Then
        XCTAssertEqual(sut.pokemonName, "")
    }
    
    func testValidPokemonNumberString() {
        // Given
        let bulbassaur = PokemonListResult(url: "https://pokeapi.co/api/v2/pokemon/1/", name: "bulbasaur")
        let sut = PokemonTableViewCellModel(listItem: bulbassaur, imageDownloader: imageDownloader)
        
        // Then
        XCTAssertEqual(sut.pokemonNumberString, "#1: ")
    }
    
    func testInvalidPokemonNumberString() {
        // Given
        let invalid = PokemonListResult(url: nil, name: nil)
        let sut = PokemonTableViewCellModel(listItem: invalid, imageDownloader: imageDownloader)
        
        // Then
        XCTAssertEqual(sut.pokemonNumberString, "")
    }

}
