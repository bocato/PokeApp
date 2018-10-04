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

protocol HomeViewControllerActionsDelegate: class { // This is related to the user interactions
    func showItemDetailsForPokemonWith(id: Int)
}

class HomeViewModel {
    
    // MARK: - Dependencies
    private let disposeBag: DisposeBag!
    private(set) weak var actionsDelegate: HomeViewControllerActionsDelegate?
    private let services: PokemonServiceProtocol
    
    // MARK: - Properties
    let pokemonCellModels = BehaviorRelay<[PokemonTableViewCellModel]>(value: [])
    let viewState = PublishSubject<CommonViewModelState>()
    
    // MARK: - Intialization
    init(actionsDelegate: HomeViewControllerActionsDelegate, services: PokemonServiceProtocol, disposeBag: DisposeBag = DisposeBag()) {
        self.actionsDelegate = actionsDelegate
        self.services = services
        self.disposeBag = disposeBag
    }
    
    // MARK: - API Calls
    func loadPokemonsObservable() -> Observable<PokemonListResponse?> {
        viewState.onNext(.loading(true))
        return services.getPokemonList()
            .do(onNext: { (pokemonListResponse) in
                guard let results = pokemonListResponse?.results, results.count > 0 else {
                    self.viewState.onNext(.empty)
                    return
                }
                let viewModelsForResult = results.map({ (listItem) -> PokemonTableViewCellModel in
                    return PokemonTableViewCellModel(listItem: listItem)
                })
                self.viewState.onNext(.loaded)
                self.pokemonCellModels.accept(viewModelsForResult)
            }, onError: { (error) in
                let networkError = error as! NetworkError
                self.viewState.onNext(.error(networkError.requestError))
            }, onCompleted: {
                self.viewState.onNext(.loading(false))
            })
    }
    
    func loadPokemons(using disposeBag: DisposeBag) {
        loadPokemonsObservable().fireSingleEvent(disposedBy: disposeBag)
    }
    
    // MARK: - Actions
    func showItemDetailsForSelectedCellModel(_ selectedPokemonCellModel: PokemonTableViewCellModel) {
        guard let id = selectedPokemonCellModel.pokemonListItem.id else { return }
        actionsDelegate?.showItemDetailsForPokemonWith(id: id)
    }
    
}
