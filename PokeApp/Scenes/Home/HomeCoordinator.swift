//
//  HomeCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

class HomeCoordinator: Coordinator {
    
    // MARK: - Outputs
    enum Output: CoordinatorOutput {
        case shouldReloadFavorites
    }
    
    // MARK: - Dependencies
    internal(set) var router: RouterProtocol
    weak internal(set) var delegate: CoordinatorDelegate?
    private let favoritesManager: FavoritesManager
    private let modulesFactory: HomeCoordinatorModulesFactory
    
    // MARK: - Properties
    internal(set) var childCoordinators: [String : Coordinator] = [:]
    internal(set) weak var parentCoordinator: Coordinator? = nil
    internal(set) var context: CoordinatorContext? // This is a struct
    
    // MARK: Initialization
    init(router: RouterProtocol, favoritesManager: FavoritesManager, modulesFactory: HomeCoordinatorModulesFactory){
        self.favoritesManager = favoritesManager
        self.modulesFactory = modulesFactory
        self.router = router
    }
    
    // MARK: - Start / Finish
    func start() {
        debugPrint("Not needed.")
    }
    
    func finish() {
        debugPrint("Not needed.")
    }
    
    // MARK: - Dealing with ouputs
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
