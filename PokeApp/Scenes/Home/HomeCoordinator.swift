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
    private(set) var modulesFactory: HomeModulesFactoryProtocol = HomeModulesFactory()
    
    // MARK: - Dealing with ouputs
    override func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
        switch (child, output) {
        case let (detailsCoordinator as DetailsCoordinator, output as DetailsCoordinator.Output):
            switch output {
            case .didAddPokemon(let pokemon):
                FavoritesManager.shared.add(pokemon: pokemon)
                self.removeChildCoordinator(detailsCoordinator)
                self.router.popModule(animated: true)
            case .didRemovePokemon(let pokemon):
                FavoritesManager.shared.remove(pokemon: pokemon)
                self.removeChildCoordinator(detailsCoordinator)
                self.router.popModule(animated: true)
            }
        default: return
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
    }
    
}
