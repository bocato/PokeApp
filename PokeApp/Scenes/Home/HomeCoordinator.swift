//
//  HomeCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

class HomeCoordinator: BaseCoordinator {
    
    // MARK: - Outputs
    enum Output: CoordinatorOutput {
        case shouldReloadFavorites
    }
    
    // MARK: - Dependencies
    private let favoritesManager: FavoritesManager
    private let modulesFactory: HomeCoordinatorModulesFactory
    
    // MARK: Initialization
    init(router: RouterProtocol, favoritesManager: FavoritesManager, modulesFactory: HomeCoordinatorModulesFactory){
        self.favoritesManager = favoritesManager
        self.modulesFactory = modulesFactory
        super.init(router: router)
    }
    
    // MARK: - Dealing with ouputs
    override func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
        switch (child, output) {
        case let (detailsCoordinator as DetailsCoordinator, output as DetailsCoordinator.Output):
            switch output {
            case .didAddPokemon(let pokemon):
                favoritesManager.add(pokemon: pokemon)
                removeChildCoordinator(detailsCoordinator)
                router.popModule(animated: true)
                let outputToSend: Output = .shouldReloadFavorites
                sendOutputToParent(outputToSend)
            case .didRemovePokemon(let pokemon):
                favoritesManager.remove(pokemon: pokemon)
                removeChildCoordinator(detailsCoordinator)
                router.popModule(animated: true)
                let outputToSend: Output = .shouldReloadFavorites
                sendOutputToParent(outputToSend)
            }
        default: return
        }
    }
    
}

extension HomeCoordinator: HomeViewControllerActionsDelegate {
    
    func showItemDetailsForPokemonWith(id: Int) {
        let router = self.router
        let (coordinator, controller) = modulesFactory.build(.pokemonDetails(id, router))
        addChildCoordinator(coordinator)
        router.push(controller, animated: true) { // completion runs on back button touched...
            weak var weakSelf = self
            weakSelf?.removeChildCoordinator(coordinator)
        }
    }
    
}
