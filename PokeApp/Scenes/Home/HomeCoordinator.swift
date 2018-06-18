//
//  HomeCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation


protocol HomeCoordinatorProtocol: Coordinator & HomeViewControllerActionsDelegate  {}

class HomeCoordinator: BaseCoordinator, HomeCoordinatorProtocol {
    
    // MARK: - Start
    override func start() {
        // Configure something if needed...
    }
    
}

extension HomeCoordinator: HomeViewControllerActionsDelegate {
    
    func showItemDetailsForPokemonWith(id: Int) {
        let services = PokemonService()
        let pokemonDetailsCoordinator = DetailsCoordinator(router: router) { [weak self] (pokemon, coordinator) in
            coordinator.router.popModule(animated: true)
            self?.removeChildCoordinator(coordinator)
        }
        let viewModel = PokemonDetailsViewModel(pokemonId: id, services: services, actionsDelegate: pokemonDetailsCoordinator)
        let pokemonDetailsViewController = PokemonDetailsViewController.newInstanceFromStoryBoard(viewModel: viewModel)
        self.addChildCoordinator(pokemonDetailsCoordinator)
        router.push(pokemonDetailsViewController)
        pokemonDetailsCoordinator.start()
    }
    
}
