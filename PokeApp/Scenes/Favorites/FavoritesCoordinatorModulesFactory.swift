//
//  FavoritesCoordinatorModulesFactory.swift
//  PokeApp
//
//  Created by Eduardo Bocato on 04/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

class FavoritesCoordinatorModulesFactory: ModuleFactory {
    
    // MARK: Aliases
    typealias ModulesEnum = Modules
    
    // MARK: - ModulesEnum
    enum Modules {
        case pokemonDetails(Int, RouterProtocol, Coordinator)
    }
    
    // MARK: Builders
    func build(_ module: Modules) -> (Coordinator, UIViewController) {
        switch module {
        case .pokemonDetails(let id, let router, let parentCoordinator):
            return buildPokemonDetailsModule(pokemonId: id, router: router, parentCoordinator: parentCoordinator)
        }
    }
    
    private func buildPokemonDetailsModule(pokemonId: Int, router: RouterProtocol, parentCoordinator: Coordinator) -> (Coordinator, UIViewController) {
        
        let pokemonDetailsCoordinator = DetailsCoordinator(router: router)
        let pokemonService = PokemonService()
        let viewModelDataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: SimpleFavoritesManager.shared)
        let viewModel = PokemonDetailsViewModel(pokemonId: pokemonId, dataSources: viewModelDataSources, actionsDelegate: pokemonDetailsCoordinator)
        let pokemonDetailsViewController = PokemonDetailsViewController.newInstanceFromStoryBoard(viewModel: viewModel)
        
        return (pokemonDetailsCoordinator, pokemonDetailsViewController)
    }
    
}
