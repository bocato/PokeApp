//
//  FavoritesModulesFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 20/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

// Interface
protocol FavoritesModulesFactoryProtocol {
    
    // MARK: - Builders
    func buildPokemonDetailsModule(pokemonId: Int,
                                   router: RouterProtocol,
                                   parentCoordinator: Coordinator)
        -> (coordinator: DetailsCoordinatorProtocol, controller: PokemonDetailsViewController)
    
}

// Implementation
class FavoritesModulesFactory: FavoritesModulesFactoryProtocol {
    
    func buildPokemonDetailsModule(pokemonId: Int,
                                   router: RouterProtocol,
                                   parentCoordinator: Coordinator)
        -> (coordinator: DetailsCoordinatorProtocol, controller: PokemonDetailsViewController) {
            
        let pokemonDetailsCoordinator = DetailsCoordinator(router: router)
        let viewModel = PokemonDetailsViewModel(pokemonId: pokemonId, services: PokemonService(), actionsDelegate: pokemonDetailsCoordinator)
        let pokemonDetailsViewController = PokemonDetailsViewController.newInstanceFromStoryBoard(viewModel: viewModel)
            
        return (pokemonDetailsCoordinator, pokemonDetailsViewController)
    }
    
}
