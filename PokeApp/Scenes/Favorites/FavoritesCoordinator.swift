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
    
    // MARK: - Outputs
    enum Output: CoordinatorOutput {
        case shouldReloadFavorites
    }
    
    // MARK: - Dependencies
    private(set) var modulesFactory: FavoritesModulesFactoryProtocol = FavoritesModulesFactory()
    
    // MARK: - Dealing with ouputs
    override func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
        switch (child, output) {
        case let (detailsCoordinator as DetailsCoordinator, output as DetailsCoordinator.Output):
            switch output {
            case .didRemovePokemon(let pokemon):
                FavoritesManager.shared.remove(pokemon: pokemon)
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
        let (coordinator, controller) = modulesFactory.buildPokemonDetailsModule(pokemonId: id, router: router, parentCoordinator: self)
        addChildCoordinator(coordinator)
        router.push(controller)
    }
    
}
