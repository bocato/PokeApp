//
//  HomeCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

protocol HomeViewControllerActions {
    func showItemDetailsForPokemonId(pokemonId: Int)
}

final class HomeCoordinator: BaseCoordinator {
    
    // MARK: - Dependencies
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: RouterProtocol
    
    // MARK: - Initialization
    init(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    // MARK: - Start
    override func start() {
        // Configure something if needed
    }
    
}

// MARK: - Flows
extension HomeCoordinator: HomeViewControllerActions {
    
    func showItemDetailsForPokemonId(pokemonId: Int) {
        let pokemonDetailsViewController = PokemonDetailsViewController.instantiateNew(withPokemonId: pokemonId) // change this? inject viewmodel?
        router.push(pokemonDetailsViewController)
    }
    
}
