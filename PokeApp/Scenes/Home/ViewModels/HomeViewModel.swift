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

protocol HomeViewControllerActionsDelegate: class {
    func showItemDetailsForPokemonWith(id: Int)
}

// MARK: - ViewModel Implementation
class HomeViewModel {
    
    // MARK: - States
    enum State {
        case common(CommonViewModelState)
    }
    
    // MARK: - Dependencies
    private let disposeBag: DisposeBag!
    private(set) weak var actionsDelegate: HomeViewControllerActionsDelegate?
    private let services: PokemonServiceProtocol
    
    // MARK: - Properties
    private(set) var pokemonCellModels = BehaviorRelay<[PokemonTableViewCellModel]>(value: [])
    private(set) var viewState = PublishSubject<State>()
    
    // MARK: - Intialization
    init(actionsDelegate: HomeViewControllerActionsDelegate, services: PokemonServiceProtocol, disposeBag: DisposeBag = DisposeBag()) {
        self.actionsDelegate = actionsDelegate
        self.services = services
        self.disposeBag = disposeBag
    }
    
    // MARK: - API Calls
    func loadPokemonsObservable() -> Observable<PokemonListResponse?> {
        viewState.onNext(.common(.loading(true)))
        return services.getPokemonList()
            .do(onNext: { (pokemonListResponse) in
                guard let results = pokemonListResponse?.results, results.count > 0 else {
                    self.viewState.onNext(.common(.empty))
                    return
                }
                let viewModelsForResult = results.map({ (listItem) -> PokemonTableViewCellModel in
                    return PokemonTableViewCellModel(listItem: listItem)
                })
                self.viewState.onNext(.common(.loaded))
                self.pokemonCellModels.accept(viewModelsForResult)
            }, onError: { (error) in
                let networkError = error as! NetworkError
                self.viewState.onNext(.common(.error(networkError.requestError)))
            }, onCompleted: {
                self.viewState.onNext(.common(.loading(false)))
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
