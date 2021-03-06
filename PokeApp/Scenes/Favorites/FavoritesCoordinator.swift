//
//  FavoritesCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 27/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

protocol FavoritesCoordinatorProtocol: Coordinator, FavoritesViewControllerActionsDelegate {
    
    // MARK: Properties
    var modulesFactory: FavoritesCoordinatorModulesFactory {get set}
    var favoritesManager: FavoritesManager {get set}
    
    // MARK: - Initialization
    init(router: RouterProtocol, modulesFactory: FavoritesCoordinatorModulesFactory, favoritesManager: FavoritesManager)
    
    // MARK: - FavoritesViewControllerActionsDelegate
    func showItemDetailsForPokemonWith(id: Int)
    
}

class FavoritesCoordinator: FavoritesCoordinatorProtocol {
    
    // MARK: - Outputs
    enum Output: CoordinatorOutput {
        case shouldReloadFavorites
    }
    
    // MARK: - Dependencies
    internal var router: RouterProtocol
    weak internal var delegate: CoordinatorDelegate?
    internal var modulesFactory: FavoritesCoordinatorModulesFactory
    internal var favoritesManager: FavoritesManager
    
    // MARK: - Properties
    internal var childCoordinators: [String : Coordinator] = [:]
    internal weak var parentCoordinator: Coordinator?
    internal var context: CoordinatorContext? // This is a struct
    
    // MARK: - Initialization
    required init(router: RouterProtocol, modulesFactory: FavoritesCoordinatorModulesFactory, favoritesManager: FavoritesManager) {
        self.modulesFactory = modulesFactory
        self.favoritesManager = favoritesManager
        self.router = router
    }
    
    // MARK: - Dealing with ouputs
    func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
        switch (child, output) {
        case let (detailsCoordinator as DetailsCoordinator, output as DetailsCoordinator.Output):
            switch output {
            case .didRemovePokemon, .didAddPokemon:
                removeChildCoordinator(detailsCoordinator)
                router.popModule(animated: true)
                let outputToSend: Output = .shouldReloadFavorites
                sendOutputToParent(outputToSend)
            }
        default: return
        }
    }
    
    // MARK: - FavoritesViewControllerActionsDelegate
    func showItemDetailsForPokemonWith(id: Int) {
        let (coordinator, controller) = modulesFactory.build(.pokemonDetails(id, router))
        addChildCoordinator(coordinator)
        router.push(controller, animated: true) {
            self.removeChildCoordinator(coordinator)
        }
    }
    
}
