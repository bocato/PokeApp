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

protocol HomeViewModelProtocol {
    
    // MARK: - Dependencies
    var disposeBag: DisposeBag { get }
    var actionsDelegate: HomeViewControllerActionsDelegate? { get }
    var services: PokemonServiceProtocol { get }

    // MARK: - Properties
    var pokemonCellModels: Variable<[PokemonTableViewCellModel]> { get }
    var viewState: Variable<HomeViewState> { get }

    // MARK: - API Calls
    func loadPokemons()

    // MARK: - Actions
    func showItemDetailsForSelectedCellModel(_ selectedPokemonCellModel: PokemonTableViewCellModel)
}

// MARK: ViewState
enum HomeViewState {
    case loading(Bool)
    case error(SerializedNetworkError?)
    case empty
}

// MARK: - ViewModel Implementation
class HomeViewModel : HomeViewModelProtocol{
    
    // MARK: - Dependencies
    internal var disposeBag = DisposeBag()
    weak var actionsDelegate: HomeViewControllerActionsDelegate?
    internal var services: PokemonServiceProtocol
    
    // MARK: - Properties
    var pokemonCellModels = Variable<[PokemonTableViewCellModel]>([])
    var viewState = Variable<HomeViewState>(.loading(true))
    
    // MARK: - Intialization
    init(actionsDelegate: HomeViewControllerActionsDelegate, services: PokemonServiceProtocol) {
        self.actionsDelegate = actionsDelegate
        self.services = services
    }
    
    // MARK: - API Calls
    func loadPokemons() {
        viewState.value = .loading(true)
        services.getPokemonList().subscribe(onNext: { pokemonListResponse in
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
            self.viewState.value = .error(networkError.requestError)
        }, onCompleted: {
            self.viewState.value = .loading(false)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    func showItemDetailsForSelectedCellModel(_ selectedPokemonCellModel: PokemonTableViewCellModel) {
        guard let id = selectedPokemonCellModel.pokemonListItem.id else { return }
        actionsDelegate?.showItemDetailsForPokemonWith(id: id)
    }
    
}
