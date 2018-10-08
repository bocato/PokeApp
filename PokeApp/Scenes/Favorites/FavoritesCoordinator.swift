//
//  FavoritesCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 27/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    
    // MARK: - Outputs
    enum Output: CoordinatorOutput {
        case shouldReloadFavorites
    }
    
    // MARK: - Dependencies
    internal(set) var router: RouterProtocol
    weak internal(set) var delegate: CoordinatorDelegate?
    private(set) var modulesFactory: FavoritesCoordinatorModulesFactory
    private(set) var favoritesManager: FavoritesManager
    
    // MARK: - Properties
    internal(set) var childCoordinators: [String : Coordinator] = [:]
    internal(set) weak var parentCoordinator: Coordinator? = nil
    internal(set) var context: CoordinatorContext? // This is a struct
    
    // MARK: - Initialization
    init(router: RouterProtocol, modulesFactory: FavoritesCoordinatorModulesFactory, favoritesManager: FavoritesManager) {
        self.modulesFactory = modulesFactory
        self.favoritesManager = favoritesManager
        self.router = router
    }
    
    // MARK: - Dealing with ouputs
    func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
        switch (child, output) {
        case let (detailsCoordinator as DetailsCoordinator, output as DetailsCoordinator.Output):
            switch output {
            case .didRemovePokemon:
                removeChildCoordinator(detailsCoordinator)
                router.popModule(animated: true)
                let outputToSend: Output = .shouldReloadFavorites
                sendOutputToParent(outputToSend)
            default: break
            }
        default: return
        }
    }
    
}

extension FavoritesCoordinator: FavoritesViewControllerActionsDelegate { // TODO: Channge this... Use, dependency injection.
    
    func showItemDetailsForPokemonWith(id: Int) {
        let (coordinator, controller) = modulesFactory.build(.pokemonDetails(id, router))
        addChildCoordinator(coordinator)
        router.push(controller, animated: true) {
            weak var weakSelf = self
            weakSelf?.removeChildCoordinator(coordinator)
        }
    }
    
}
