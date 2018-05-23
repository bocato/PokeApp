//
//  PokemonService.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 15/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift

protocol PokemonServiceProtocol {
    func getPokemonList(_ limit: Int) -> Observable<(PokemonListResponse?, NetworkResponse?)>
}

class PokemonService: PokemonServiceProtocol {
    
    // MARK: - Properties
    private let endpoint = "pokemon"
    private var dispatcher: NetworkDispatcherProtocol
    
    // MARK: - Initializers
    init() {
        let url = URL(string: Environment.shared.baseURL!)?.appendingPathComponent(endpoint)
        dispatcher = NetworkDispatcher(url: url!)
    }
    
    init(dispatcher: NetworkDispatcherProtocol) {
        self.dispatcher = dispatcher
    }
    
    // MARK: - Services
    func getPokemonList(_ limit: Int = 150) -> Observable<(PokemonListResponse?, NetworkResponse?)> {
        
        let queryParameters = URLHelper.escapedParameters(["limit": limit])
        let path = queryParameters
        
        return dispatcher.response(of: PokemonListResponse.self, from: path, method: .get, payload: nil, headers: nil)
    }
    
    func getDetailsForPokemon(withId id: Int) -> Observable<(Pokemon?, NetworkResponse?)> {
    
        let path = "/\(id)"
        
        return dispatcher.response(of: Pokemon.self, from: path, method: .get, payload: nil, headers: nil)
    }
    
}
