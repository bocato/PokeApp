//
//  HomeCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

protocol HomeCoordinatorProtocol: Coordinator, HomeViewControllerActionsDelegate {
    
    // MARK: Dependencies
    var favoritesManager: FavoritesManager {get set}
    var modulesFactory: HomeCoordinatorModulesFactory {get set}
    
    // MARK: - Initialization
    init(router: RouterProtocol, favoritesManager: FavoritesManager, modulesFactory: HomeCoordinatorModulesFactory)
    
    // MARK: - HomeViewControllerActionsDelegate
    func showItemDetailsForPokemonWith(id: Int)
    
}

class HomeCoordinator: HomeCoordinatorProtocol {
    
    // MARK: - Outputs
    enum Output: CoordinatorOutput {
        case shouldReloadFavorites
    }
    
    // MARK: - Dependencies
    internal(set) var router: RouterProtocol
    weak internal(set) var delegate: CoordinatorDelegate?
    internal(set) var favoritesManager: FavoritesManager
    internal(set) var modulesFactory: HomeCoordinatorModulesFactory
    
    // MARK: - Properties
    internal(set) var childCoordinators: [String : Coordinator] = [:]
    internal(set) weak var parentCoordinator: Coordinator? = nil
    internal(set) var context: CoordinatorContext? // This is a struct
    
    // MARK: Initialization
    required init(router: RouterProtocol, favoritesManager: FavoritesManager, modulesFactory: HomeCoordinatorModulesFactory) {
        self.favoritesManager = favoritesManager
        self.modulesFactory = modulesFactory
        self.router = router
    }
    
    // MARK: - Outputs
    func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
        switch (child, output) {
        case let (detailsCoordinator as DetailsCoordinator, output as DetailsCoordinator.Output):
            switch output {
            case .didAddPokemon, .didRemovePokemon:
                router.popModule(animated: true)
                removeChildCoordinator(detailsCoordinator)
                let outputToSend: Output = .shouldReloadFavorites
                sendOutputToParent(outputToSend)
            }
        default: return
        }
    }
    
    // MARK: - HomeViewControllerActionsDelegate
    func showItemDetailsForPokemonWith(id: Int) {
        let (coordinator, controller) = modulesFactory.build(.pokemonDetails(id, router))
        addChildCoordinator(coordinator)
        router.push(controller, animated: true) { // completion runs on back button touched...
            self.removeChildCoordinator(coordinator)
        }
    }
    
}
