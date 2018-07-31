//
//  HomeViewModelTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 31/07/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
import RxSwift
@testable import PokeApp

class HomeViewModelTests: XCTestCase {
    
    // MARK: - Properties
    var sut: HomeViewModelTests!
    var actionsDelegateStub: HomeViewControllerActionsDelegateStub!
    var pokemonServices: PokemonService!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        actionsDelegateStub = HomeViewControllerActionsDelegateStub()
        pokemonServices = PokemonService()
//        sut = HomeViewModel(actionsDelegate: actionsDelegateStub, services: pokemonServices)
    }
    
    // MARK: - Tests
    
    
}


class HomeViewControllerActionsDelegateStub: HomeViewControllerActionsDelegate {
    
    var showItemDetailsForPokemonWithIdWasCalled = false
    var pokemonIdToShowDetails: Int?
    
    func showItemDetailsForPokemonWith(id: Int) {
        showItemDetailsForPokemonWithIdWasCalled = true
        pokemonIdToShowDetails = id
    }
    
}

class PokemonServiceStub: PokemonServiceProtocol {
    
    func getPokemonList() -> Observable<PokemonListResponse?> {
        let pokemonListResults = [PokemonListResult(url: "http://www.pokemon.com", name: "Pokemon Name")]
        let pokemonListResponse = PokemonListResponse(count: 1, previous: "previous", results: pokemonListResults, next: "next")
        return Observable.just(pokemonListResponse)
    }
    
    func getPokemonList(_ limit: Int) -> Observable<PokemonListResponse?> {
        return Observable.just(nil)
    }
    
    func getDetailsForPokemon(withId id: Int) -> Observable<Pokemon?> {
        return Observable.just(nil)
    }
    
}
