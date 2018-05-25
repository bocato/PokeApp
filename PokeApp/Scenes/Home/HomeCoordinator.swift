//
//  HomeCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

protocol HomeCoordinatorActions {
    func showItemDetailsForPokemonId(pokemonId: Int)
}

final class HomeCoordinator: BaseCoordinator {
    
    // MARK: - Dependencies
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: Router
    
    // MARK: - Initialization
    init(router: Router, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    // MARK: - Start
    override func start() {
        showPokemonsList()
    }
    
    // MARKL: - Flows
    private func showPokemonsList() {
        let (coordinator, controller) = coordinatorFactory.createHomeCoordinator(router: router)
        addChildCoordinator(coordinator)
        router.present(controller)
        coordinator.start()
    }
    
    
    
}
