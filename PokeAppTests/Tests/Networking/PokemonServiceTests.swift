//
//  PokemonServiceTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 20/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class PokemonServiceTests: XCTestCase {
    
    // MARK: Properties
    var url: URL!
    var service: PokemonService!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        url = URL(string: Environment.shared.baseURL!)?.appendingPathComponent("pokemon")
        let dispatcher = NetworkDispatcherStub(url: url!)
        service = PokemonService(dispatcher : dispatcher)
    }
    
    override func tearDown() {
        super.tearDown()
        url = nil
        service = nil
    }
    
    // MARK: - Tests
    func testInit() {
        let service = PokemonService()
        XCTAssertEqual(service.dispatcher.url, url, "Wrong url")
    }
    
    func testGetPokemonList() {

        let response = service.getPokemonList()
        let collector = RxCollector<PokemonListResponse?>()
            .collect(from: response)

        guard let error = collector.error as? NetworkError,
            let request = error.request, request.url != nil else {
                XCTAssert(false, "Request url not found")
                return
        }

    }
    
    func testGetPokemonListLimit50() {
        
        let limit = 50
        
        let response = service.getPokemonList(limit)
        let collector = RxCollector<PokemonListResponse?>()
            .collect(from: response)
        
        guard let error = collector.error as? NetworkError,
            let requestURL = error.request?.url else {
                XCTAssert(false, "Request url not found")
                return
        }
        
        XCTAssertTrue(requestURL.contains(key: "limit"), "limit path component not found")
        
        XCTAssertEqual(requestURL.valueOf("limit"), "\(limit)", "Invalid limit")
        
    }
    
    func testGetDetailsForPokemonWithId10() {
        
        let pokemonId = 10
        
        let response = service.getDetailsForPokemon(withId: pokemonId)
        let collector = RxCollector<Pokemon?>()
            .collect(from: response)
        
        guard let error = collector.error as? NetworkError,
            let requestURL = error.request?.url else {
                XCTAssert(false, "Request url not found")
                return
        }
        
        XCTAssertEqual(requestURL.lastPathComponent, "\(pokemonId)", "invalid id")
        
    }
    
    
}
