//
//  FavoritesCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 27/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

protocol FavoritesViewControllerActions {
    func showItemDetailsForPokemonWith(id: Int)
}

protocol FavoritesCoordinatorProtocol: Coordinator & FavoritesViewControllerActions {}

class FavoritesCoordinator: BaseCoordinator, FavoritesCoordinatorProtocol {
    
    // MARK: - Start
    override func start() {
        // Configure something if needed...
    }
    
}

extension FavoritesCoordinator: FavoritesViewControllerActions {
    
    func showItemDetailsForPokemonWith(id: Int) {
        let services = PokemonService()
        let viewModel = PokemonDetailsViewModel(pokemonId: id, services: services, coordinator: self)
        let pokemonDetailsViewController = PokemonDetailsViewController.newInstanceFromStoryBoard(viewModel: viewModel)
        router.push(pokemonDetailsViewController)
    }
    
}
