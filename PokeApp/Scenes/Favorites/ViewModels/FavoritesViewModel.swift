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
    
    // MARK: - Properties
    
    
    // MARK: - RXProperties
    var favoritesCellModels = Variable<[FavoriteCollectionViewCellModel]?>([])
    
    // MARK: - Initialzation
    init() {
        loadFavorites()
    }
    
    // MARK: -
    private func loadFavorites() { // TODO: Refactor
        favoritesCellModels.value = FavoritesManager.shared.favorites.map({ (pokemon) -> FavoriteCollectionViewCellModel in
            return FavoriteCollectionViewCellModel(data: pokemon)
        })
    }
    
}
