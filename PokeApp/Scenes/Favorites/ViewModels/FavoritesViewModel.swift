//
//  FavoritesViewModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift

protocol FavoritesActionsDelegate: class {
    func showItemDetailsForPokemonWith(id: Int)
}

class FavoritesViewModel {
    
    // MARK: ViewState
    enum HomeViewState {
        case loading(Bool)
        case error(SerializedNetworkError)
        case empty
    }
    
    // MARK: - Dependecies
    weak var actionsDelegate: FavoritesActionsDelegate?
    
    // MARK: - Properties
    
    // MARK: - RXProperties
    var viewState = Variable<HomeViewState>(.loading(false))
    var favoritesCellModels = Variable<[FavoriteCollectionViewCellModel]>([])
    
    // MARK: - Initialzation
    init(actionsDelegate: FavoritesActionsDelegate) {
        self.actionsDelegate = actionsDelegate
    }
    
    // MARK: -
    func loadFavorites() { // TODO: Refactor
//        self.viewState.value = .loading(true)
        let favoritesCellModels = FavoritesManager.shared.favorites.map({ (pokemon) -> FavoriteCollectionViewCellModel in
            return FavoriteCollectionViewCellModel(data: pokemon)
        })
        self.favoritesCellModels.value = favoritesCellModels
//        self.viewState.value = .loading(false)
//        if favoritesCellModels.count == 0 {
//            self.viewState.value = .empty
//        }
    }
    
    // MARK: - Actions
    func showItemDetailsForSelectedFavoriteCellModel(favoriteCellModel: FavoriteCollectionViewCellModel) {
        guard let id = favoriteCellModel.pokemonData.id else { return }
        self.actionsDelegate?.showItemDetailsForPokemonWith(id: id)
    }
    
}
