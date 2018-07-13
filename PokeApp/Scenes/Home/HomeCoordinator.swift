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

class HomeCoordinator: BaseCoordinator, HomeCoordinatorProtocol {
    
    // MARK: - Dependencies
    var modulesFactory: HomeModulesFactoryProtocol = HomeModulesFactory()
    
    // MARK: - Start
    override func start() {
        // Configure something if needed...
    }
    
}

extension HomeCoordinator: HomeViewControllerActionsDelegate {
    
    func showItemDetailsForPokemonWith(id: Int) {
        let (coordinator, controller) = modulesFactory.buildPokemonDetailsModule(pokemonId: id, router: router) { [weak self] (output, detailsCoordinator) in
            detailsCoordinator.router.popModule(animated: true)
            self?.removeChildCoordinator(detailsCoordinator)
        }
        addChildCoordinator(coordinator)
        router.push(controller, animated: true) { // completion runs on back button pressed...
            weak var weakSelf = self
            weakSelf?.removeChildCoordinator(coordinator)
        }
        coordinator.start()
    }
    
}
