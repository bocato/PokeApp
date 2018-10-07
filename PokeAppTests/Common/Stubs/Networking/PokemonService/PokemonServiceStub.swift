//
//  PokemonServiceStub.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 07/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
@testable import PokeApp
import RxSwift

class PokemonServiceStub: PokemonServiceProtocol {
    
    enum Response {
        case something
    }
    
    var response: Response?
    
    func getPokemonList() -> Observable<PokemonListResponse?> {
        return Observable.of(nil)
    }
    
    func getPokemonList(_ limit: Int) -> Observable<PokemonListResponse?> {
        return Observable.of(nil)
    }
    
    func getDetailsForPokemon(withId id: Int) -> Observable<Pokemon?> {
       return Observable.of(nil)
    }
    
}
