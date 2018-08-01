//
//  HomeCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation


protocol HomeCoordinatorProtocol: Coordinator & HomeViewControllerActionsDelegate {
    // MARK: - Dependencies
    var modulesFactory: HomeModulesFactoryProtocol { get }
}

class HomeCoordinator: HomeCoordinatorProtocol {
    
    // MARK: - Dependencies
    private(set) var modulesFactory: HomeModulesFactoryProtocol = HomeModulesFactory()
    internal(set) var router: RouterProtocol
    internal(set) var delegate: CoordinatorDelegate?
    
    // MARK: - Properties
    internal(set) var childCoordinators: [String : Coordinator] = [:]
    internal(set) var parentCoordinator: Coordinator?
    internal(set) var identifier: String = "HomeCoordinator"
    
    // MARK: - Initialization
    required init(router: RouterProtocol) {
        self.router = router
    }
    
}

extension HomeCoordinator: CoordinatorDelegate {
    
    func finish(_ coordinator: Coordinator, output: CoordinatorInfo) {
        if coordinator.identifier == "DetailsCoordinator" {
            coordinator.router.popModule(animated: true)
            removeChildCoordinator(coordinator)
        }
    }
    
}

extension HomeCoordinator: HomeViewControllerActionsDelegate {
    
    func showItemDetailsForPokemonWith(id: Int) {
        let router = self.router
        let (coordinator, controller) = modulesFactory.buildPokemonDetailsModule(pokemonId: id, router: router)
        addChildCoordinator(coordinator)
        router.push(controller, animated: true) { // completion runs on back button pressed...
            weak var weakSelf = self
            weakSelf?.removeChildCoordinator(coordinator)
        }
        coordinator.start()
    }
    
}
