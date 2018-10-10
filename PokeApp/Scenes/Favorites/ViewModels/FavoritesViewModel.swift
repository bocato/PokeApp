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

class FavoritesViewModel: CoordinatorDelegate {
    
    // MARK: - Dependencies
    weak var actionsDelegate: FavoritesViewControllerActionsDelegate?
    let favoritesManager: FavoritesManager
    let imageDownloader: ImageDownloaderProtocol
    
    // MARK: - RXProperties
    let viewState = PublishSubject<CommonViewModelState>()
    let favoritesCellModels = PublishSubject<[FavoriteCollectionViewCellModel]>()
    
    // MARK: Properties
    private(set) var numberFavorites = 0
    
    // MARK: - Initialzation
    init(actionsDelegate: FavoritesViewControllerActionsDelegate, favoritesManager: FavoritesManager, imageDownloader: ImageDownloaderProtocol) {
        self.actionsDelegate = actionsDelegate
        self.favoritesManager = favoritesManager
        self.imageDownloader = imageDownloader
    }
    
    // MARK: -
    func loadFavorites() {
        let cellModels = favoritesManager.favorites
                .sorted(by: { $0.id! < $1.id! })
                .map({ (pokemon) -> FavoriteCollectionViewCellModel in
                    return FavoriteCollectionViewCellModel(data: pokemon, imageDownloader: self.imageDownloader)
                })
        numberFavorites = cellModels.count
        favoritesCellModels.onNext(cellModels)
        viewState.onNext(cellModels.count == 0 ? .empty : .loaded)
    }
    
    // MARK: - Actions
    func showItemDetailsForSelectedFavoriteCellModel(favoriteCellModel: FavoriteCollectionViewCellModel) {
        guard let id = favoriteCellModel.pokemonData.id else { return }
        actionsDelegate?.showItemDetailsForPokemonWith(id: id)
    }
    
    // MARK: - CoordinatorDelegate
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
        default: return
        }
    }
    
}
