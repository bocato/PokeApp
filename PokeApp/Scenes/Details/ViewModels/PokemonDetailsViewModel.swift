//
//  PokemonDetailsViewModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 22/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift

class PokemonDetailsViewModel {
    
    // MARK: - ViewState
    enum PokemonDetailsViewState {
        case loading(Bool)
        case error(NetworkError)
        case noData
    }
    
    // MARK: - Dependencies
    private let pokemonService = PokemonService()
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    private var pokemonId: Int!
    var pokemonData = Variable<Pokemon?>(nil)
    var viewState = Variable<PokemonDetailsViewState>(.loading(true))
    
    // MARK: - Initialization
    required init(pokemonId: Int) {
        self.pokemonId = pokemonId
        self.loadPokemonData()
    }
    
    // MARK: - API Calls
    private func loadPokemonData() {
        viewState.value = .loading(true)
        pokemonService.getDetailsForPokemon(withId: pokemonId)
            .subscribe(onNext: { (pokemonData, _) in
                guard let pokemonData = pokemonData else {
                    self.viewState.value = .noData
                    self.pokemonData.value = nil
                    return
                }
                self.pokemonData.value = pokemonData
            }, onError: { (error) in
                let networkError = error as! NetworkError
                self.viewState.value = .error(networkError)
            }, onCompleted: {
                self.viewState.value = .loading(false)
            })
    }
    
}
