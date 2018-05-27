//
//  HomeCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

protocol HomeViewControllerActions {
    func showItemDetailsForPokemonWith(id: Int)
}

protocol HomeCoordinatorProtocol: Coordinator & HomeViewControllerActions {}

class HomeCoordinator: BaseCoordinator, HomeCoordinatorProtocol {
    
    // MARK: - Start
    override func start() {
        // Configure something if needed...
    }
    
}

extension HomeCoordinator: HomeViewControllerActions {
    
    func showItemDetailsForPokemonWith(id: Int) {
        let services = PokemonService()
        let viewModel = PokemonDetailsViewModel(pokemonId: id, services: services, coordinator: self)
        let pokemonDetailsViewController = PokemonDetailsViewController.newInstanceFromStoryBoard(viewModel: viewModel)
        router.push(pokemonDetailsViewController)
    }
    
}
