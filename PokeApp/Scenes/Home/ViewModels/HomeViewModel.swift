//
//  HomeViewModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 20/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    
    // MARK: ViewState
    enum HomeViewState {
        case loading(Bool)
        case error(NetworkError)
        case empty
    }
    
    // MARK: - Dependencies
    private let disposeBag = DisposeBag()
    let coordinator: HomeCoordinator
    private let services: PokemonService
    
    // MARK: - Properties
    var pokemonCellModels = Variable<[PokemonTableViewCellModel]>([])
    var viewState = Variable<HomeViewState>(.loading(true))
    
    // MARK: - Intialization
    init(coordinator: HomeCoordinator, services: PokemonService) {
        self.coordinator = coordinator
        self.services = services
    }
    
    // MARK: - API Calls
    func loadPokemons() {
        viewState.value = .loading(true)
        services.getPokemonList().subscribe(onNext: { (pokemonListResponse, _) in
            guard let results = pokemonListResponse?.results else {
                self.viewState.value = .empty
                self.pokemonCellModels.value = []
                return
            }
            self.pokemonCellModels.value = results.map({ (listItem) -> PokemonTableViewCellModel in
                return PokemonTableViewCellModel(listItem: listItem)
            })
        }, onError: { (error) in
            let networkError = error as! NetworkError
            self.viewState.value = .error(networkError)
        }, onCompleted: {
            self.viewState.value = .loading(false)
        }).disposed(by: disposeBag)
    }
    
}
