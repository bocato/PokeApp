//
//  FavoritesCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 27/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

protocol FavoritesCoordinatorProtocol: Coordinator & FavoritesViewControllerActionsDelegate {
    // MARK: - Dependencies
    var modulesFactory: FavoritesModulesFactoryProtocol { get }
}

class FavoritesCoordinator: BaseCoordinator, FavoritesCoordinatorProtocol {
    
    // MARK: - Dependencies
    var modulesFactory: FavoritesModulesFactoryProtocol = FavoritesModulesFactory()
    
    // MARK: - Start
    override func start() {
        // Configure something if needed...
    }
    
}

extension FavoritesCoordinator: FavoritesViewControllerActionsDelegate {
    
    func showItemDetailsForPokemonWith(id: Int) {
        let (coordinator, controller) = modulesFactory.buildPokemonDetailsModule(pokemonId: id, router: router) { [weak self] (output, detailsCoordinator) in
            detailsCoordinator.router.popModule(animated: true)
            self?.removeChildCoordinator(detailsCoordinator)
        }
        self.addChildCoordinator(coordinator)
        router.push(controller)
        coordinator.start()
    }
    
}
