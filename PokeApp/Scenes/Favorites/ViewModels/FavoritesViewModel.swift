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

    // MARK: - State
    enum State {
        case loading(Bool)
        case loaded
        case empty
    }
    
    // MARK: - Dependencies
    var actionsDelegate: FavoritesViewControllerActionsDelegate? // need to make this weak
    
    // MARK: - RXProperties
    var viewState = BehaviorRelay<State>(value: .loading(true))
    var favoritesCellModels = PublishSubject<[FavoriteCollectionViewCellModel]>()
    
    // MARK: - Initialzation
    init(actionsDelegate: FavoritesViewControllerActionsDelegate) {
        self.actionsDelegate = actionsDelegate
    }
    
    // MARK: -
    func loadFavorites() {
        self.viewState.accept(.loading(true))
        let favoritesCellModels = FavoritesManager.shared.favorites.map({ (pokemon) -> FavoriteCollectionViewCellModel in
            return FavoriteCollectionViewCellModel(data: pokemon)
        })
        self.favoritesCellModels.onNext(favoritesCellModels)
        self.viewState.accept(.loading(false))
        self.viewState.accept(favoritesCellModels.count == 0 ? .empty : .loaded)
    }
    
    // MARK: - Actions
    func showItemDetailsForSelectedFavoriteCellModel(favoriteCellModel: FavoriteCollectionViewCellModel) {
        guard let id = favoriteCellModel.pokemonData.id else { return }
        self.actionsDelegate?.showItemDetailsForPokemonWith(id: id)
    }
    
}
