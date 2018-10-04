//
//  HomeModulesFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 12/07/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

class HomeCoordinatorModulesFactory: ModuleFactory {
    
    // MARK: Aliases
    typealias ModulesEnum = Modules
    
    // MARK: - ModulesEnum
    enum Modules {
        case pokemonDetails(Int, RouterProtocol)
    }
    
    // MARK: Builders
    func build(_ module: Modules) -> (Coordinator, UIViewController) {
        switch module {
        case .pokemonDetails(let id, let router):
            return buildPokemonDetailsModule(pokemonId: id, router: router)
        }
    }
    
    private func buildPokemonDetailsModule(pokemonId: Int, router: RouterProtocol) -> (Coordinator, UIViewController) {
        
        let pokemonDetailsCoordinator = DetailsCoordinator(router: router)
        let pokemonService = PokemonService()
        let viewModelDataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: SimpleFavoritesManager.shared)
        let viewModel = PokemonDetailsViewModel(pokemonId: pokemonId, dataSources: viewModelDataSources, actionsDelegate: pokemonDetailsCoordinator)
        let pokemonDetailsViewController = PokemonDetailsViewController.newInstance(fromStoryboard: .details, viewModel: viewModel)
        
        return (pokemonDetailsCoordinator, pokemonDetailsViewController)
    }
    
}
