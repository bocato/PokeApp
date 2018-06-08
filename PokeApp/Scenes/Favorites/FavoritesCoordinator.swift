//
//  FavoritesCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 27/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

protocol FavoritesCoordinatorProtocol: Coordinator & FavoritesViewControllerActionsDelegate {}

class FavoritesCoordinator: BaseCoordinator, FavoritesCoordinatorProtocol {
    
    // MARK: - Start
    override func start() {
        // Configure something if needed...
    }
    
}

extension FavoritesCoordinator: FavoritesViewControllerActionsDelegate {
    
    func showItemDetailsForPokemonWith(id: Int) {
        let services = PokemonService()
        let viewModel = PokemonDetailsViewModel(pokemonId: id, services: services)
        let pokemonDetailsViewController = PokemonDetailsViewController.newInstanceFromStoryBoard(viewModel: viewModel)
        router.push(pokemonDetailsViewController)
    }
    
}
