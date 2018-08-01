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

class FavoritesCoordinator: FavoritesCoordinatorProtocol {
    
    // MARK: - Dependencies
    private(set) var modulesFactory: FavoritesModulesFactoryProtocol = FavoritesModulesFactory()
    internal(set) var router: RouterProtocol
    internal(set) var delegate: CoordinatorDelegate?
    
    // MARK: - Properties
    var childCoordinators: [String : Coordinator] = [:]
    var parentCoordinator: Coordinator?
    internal(set) var identifier: String = "FavoritesCoordinator"
    
    // MARK: - Initialization
    required init(router: RouterProtocol) {
        self.router = router
    }
    
}

extension FavoritesCoordinator: CoordinatorDelegate {
    
    func finish(_ coordinator: Coordinator, output: CoordinatorInfo) {
        debugPrint("coisa")
    }
    
}

extension FavoritesCoordinator: FavoritesViewControllerActionsDelegate {
    
    func showItemDetailsForPokemonWith(id: Int) {
        let router = self.router
        let (coordinator, controller) = modulesFactory.buildPokemonDetailsModule(pokemonId: id, router: router, parentCoordinator: self)
//        let (coordinator, controller) = modulesFactory.buildPokemonDetailsModule(pokemonId: id, router: router) { [weak self] (output, detailsCoordinator) in
//            detailsCoordinator.router.popModule(animated: true)
//            self?.removeChildCoordinator(detailsCoordinator)
//        }
        self.addChildCoordinator(coordinator)
        router.push(controller)
        coordinator.start()
    }
    
}
