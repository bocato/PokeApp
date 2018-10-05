//
//  FavoritesViewModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol FavoritesViewControllerActionsDelegate: class {
    func showItemDetailsForPokemonWith(id: Int)
}

class FavoritesViewModel {
    
    // MARK: - Dependencies
    weak var actionsDelegate: FavoritesViewControllerActionsDelegate?
    internal(set) var favoritesManager: FavoritesManager
    
    // MARK: - RXProperties
    let viewState = PublishSubject<CommonViewModelState>()
    let favoritesCellModels = PublishSubject<[FavoriteCollectionViewCellModel]>()
    
    // MARK: Properties
    private(set) var numberFavorites = 0
    
    // MARK: - Initialzation
    init(actionsDelegate: FavoritesViewControllerActionsDelegate, favoritesManager: FavoritesManager) {
        self.actionsDelegate = actionsDelegate
        self.favoritesManager = favoritesManager
    }
    
    // MARK: -
    func loadFavorites() {
        let favoritesCellModels = favoritesManager.favorites.map({ (pokemon) -> FavoriteCollectionViewCellModel in
            return FavoriteCollectionViewCellModel(data: pokemon)
        }).sorted { (pokemon1, pokemon2) -> Bool in
            guard let id1 = pokemon1.pokemonData.id, let id2 = pokemon2.pokemonData.id else { return false }
            return id1 < id2
        }
        numberFavorites = favoritesCellModels.count
        self.favoritesCellModels.onNext(favoritesCellModels)
        viewState.onNext(favoritesCellModels.count == 0 ? .empty : .loaded)
    }
    
    // MARK: - Actions
    func showItemDetailsForSelectedFavoriteCellModel(favoriteCellModel: FavoriteCollectionViewCellModel) {
        guard let id = favoriteCellModel.pokemonData.id else { return }
        actionsDelegate?.showItemDetailsForPokemonWith(id: id)
    }
    
}

extension FavoritesViewModel: CoordinatorDelegate {
    
    func receiveOutput(_ output: CoordinatorOutput, fromCoordinator coordinator: Coordinator) {
        switch (coordinator, output) {
        case let (_, output as HomeCoordinator.Output):
            switch output {
            case .shouldReloadFavorites:
                loadFavorites()
            }
        case let (_, output as FavoritesCoordinator.Output):
            switch output {
            case .shouldReloadFavorites:
                loadFavorites()
            }
        default: break
        }
    }
    
}
