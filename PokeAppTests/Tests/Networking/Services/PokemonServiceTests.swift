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
    let url = URL(string: Environment.shared.baseURL!)?.appendingPathComponent("pokemon")
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Performance
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: - Tests
    func testInit() {
        let service = PokemonService()
        XCTAssertEqual(service.dispatcher.url, url, "Wrong url")
    }
    
    func testGetPokemonList() {
        
        let dispatcher = NetworkDispatcherStub(url: url!)
        let service = PokemonService(dispatcher : dispatcher)
        let response = service.getPokemonList()
        let collector = RxCollector<PokemonListResponse?>()
            .collect(from: response)
        
        guard let error = collector.error as? NetworkError,
            let _ = error.request?.url else {
                XCTAssert(false, "Request url not found")
                return
        }
        
    }
    
    func testGetPokemonList(_ limit: Int) {
        
        let limit = 50
        let limitComponentIndex = 0
        
        let dispatcher = NetworkDispatcherStub(url: url!)
        let service = PokemonService(dispatcher : dispatcher)
        let response = service.getPokemonList(limit)
        let collector = RxCollector<PokemonListResponse?>()
            .collect(from: response)
        
        guard let error = collector.error as? NetworkError,
            let requestURL = error.request?.url else {
                XCTAssert(false, "Request url not found")
                return
        }
        
        XCTAssertEqual(requestURL.pathComponents[limitComponentIndex], "limit", "limit path component not found")
        
        XCTAssertEqual(requestURL.valueOf("limit"), "\(limit)", "Invalid limit")
        
    }
    
    func testGetDetailsForPokemon(withId id: Int) {
        
        let pokemonId = 10
        let idComponentIndex = 0
        
        let dispatcher = NetworkDispatcherStub(url: url!)
        let service = PokemonService(dispatcher : dispatcher)
        let response = service.getDetailsForPokemon(withId: pokemonId)
        let collector = RxCollector<Pokemon?>()
            .collect(from: response)
        
        guard let error = collector.error as? NetworkError,
            let requestURL = error.request?.url else {
                XCTAssert(false, "Request url not found")
                return
        }
        
        XCTAssertEqual(requestURL.pathComponents[idComponentIndex], "\(pokemonId)", "id path component not found")
        
    }
    
    
}
