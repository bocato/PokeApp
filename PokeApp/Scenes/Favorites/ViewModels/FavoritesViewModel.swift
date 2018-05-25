//
//  FavoritesViewModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift

class FavoritesViewModel {
    
    // MARK: ViewState
    enum HomeViewState {
        case loading(Bool)
        case error(NetworkError)
        case empty
    }
    
    // MARK: - Properties
    
    // MARK: - RXProperties
    var viewState = Variable<HomeViewState>(.loading(true))
    var favoritesCellModels = Variable<[FavoriteCollectionViewCellModel]>([])
    
    // MARK: - Initialzation
    
    
    // MARK: -
    func loadFavorites() { // TODO: Refactor
        favoritesCellModels.value = FavoritesManager.shared.favorites.map({ (pokemon) -> FavoriteCollectionViewCellModel in
            return FavoriteCollectionViewCellModel(data: pokemon)
        })
    }
    
}
