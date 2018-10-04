//
//  FavoritesCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 27/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

class FavoritesCoordinator: BaseCoordinator {
    
    // MARK: - Outputs
    enum Output: CoordinatorOutput {
        case shouldReloadFavorites
    }
    
    // MARK: - Dependencies
    private(set) var modulesFactory: FavoritesCoordinatorModulesFactory
    private(set) var favoritesManager: FavoritesManager
    
    // MARK: - Initialization
    init(router: RouterProtocol, modulesFactory: FavoritesCoordinatorModulesFactory, favoritesManager: FavoritesManager) {
        self.modulesFactory = modulesFactory
        self.favoritesManager = favoritesManager
        super.init(router: router)
    }
    
    // MARK: - Dealing with ouputs
    override func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
        switch (child, output) {
        case let (detailsCoordinator as DetailsCoordinator, output as DetailsCoordinator.Output):
            switch output {
            case .didRemovePokemon(let pokemon):
                favoritesManager.remove(pokemon: pokemon)
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

extension FavoritesCoordinator: FavoritesViewControllerActionsDelegate {
    
    func showItemDetailsForPokemonWith(id: Int) {
        let router = self.router
        let (coordinator, controller) = modulesFactory.build(.pokemonDetails(id, router, self))
        addChildCoordinator(coordinator)
        router.push(controller)
    }
    
}
