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
        case loading(Bool)
        case error(SerializedNetworkError?)
        case empty
    }
    
    // MARK: - Dependencies
    private let disposeBag = DisposeBag()
    private(set) weak var actionsDelegate: HomeViewControllerActionsDelegate?
    private let services: PokemonServiceProtocol
    
    // MARK: - Properties
    private(set) var pokemonCellModels = BehaviorRelay<[PokemonTableViewCellModel]>(value: [])
    private(set) var viewState = BehaviorRelay<State>(value: .loading(true))
    
    // MARK: - Intialization
    init(actionsDelegate: HomeViewControllerActionsDelegate, services: PokemonServiceProtocol) {
        self.actionsDelegate = actionsDelegate
        self.services = services
    }
    
    // MARK: - API Calls
    func loadPokemons() -> Observable<PokemonListResponse?> {
        viewState.accept(.loading(true))
        let serviceObservable = services.getPokemonList()
            .do(onNext: { (pokemonListResponse) in
                guard let results = pokemonListResponse?.results, results.count > 0 else {
                    self.viewState.accept(.empty)
                    return
                }
                let viewModelsForResult = results.map({ (listItem) -> PokemonTableViewCellModel in
                    return PokemonTableViewCellModel(listItem: listItem)
                })
                if viewModelsForResult.count == 0 {
                    self.viewState.accept(.empty)
                }
                self.pokemonCellModels.accept(viewModelsForResult)
            }, onError: { (error) in
                let networkError = error as! NetworkError
                self.viewState.accept(.error(networkError.requestError))
            }, onCompleted: {
                self.viewState.accept(.loading(false))
            })
//            .subscribeOn(MainScheduler.instance)
//            .subscribe(onNext: { pokemonListResponse in
//                guard let results = pokemonListResponse?.results, results.count > 0 else {
//                    self.viewState.accept(.empty)
//                    return
//                }
//                let viewModelsForResult = results.map({ (listItem) -> PokemonTableViewCellModel in
//                    return PokemonTableViewCellModel(listItem: listItem)
//                })
//                if viewModelsForResult.count == 0 {
//                    self.viewState.accept(.empty)
//                }
//                self.pokemonCellModels.accept(viewModelsForResult)
//            }, onError: { (error) in
//                let networkError = error as! NetworkError
//                self.viewState.accept(.error(networkError.requestError))
//            }, onCompleted: {
//                self.viewState.accept(.loading(false))
//            })
//            .disposed(by: disposeBag)
        return serviceObservable
    }
    
    // MARK: - Actions
    func showItemDetailsForSelectedCellModel(_ selectedPokemonCellModel: PokemonTableViewCellModel) {
        guard let id = selectedPokemonCellModel.pokemonListItem.id else { return }
        actionsDelegate?.showItemDetailsForPokemonWith(id: id)
    }
    
}
