//
//  FavoritesViewModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift

protocol FavoritesViewControllerActionsDelegate: class {
    func showItemDetailsForPokemonWith(id: Int)
}

class FavoritesViewModel {

    // MARK: - Dependecies
    var actionsDelegate: FavoritesViewControllerActionsDelegate? // need to make this weak
    
    // MARK: - Properties
    
    // MARK: - RXProperties
    var favoritesCellModels = Variable<[FavoriteCollectionViewCellModel]>([])
    
    // MARK: - Initialzation
    init(actionsDelegate: FavoritesViewControllerActionsDelegate) {
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
