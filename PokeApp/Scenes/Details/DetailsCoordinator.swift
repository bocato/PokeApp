//
//  DetailsCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 08/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

protocol DetailsCoordinatorProtocol: Coordinator, PokemonDetailsViewControllerActionsDelegate {
    
    // MARK: - Initialization
    init(router: RouterProtocol)
    
    // MARK: - PokemonDetailsViewControllerActionsDelegate
    func didAddFavorite(_ pokemon: Pokemon)
    func didRemoveFavorite(_ pokemon: Pokemon)
    
}

class DetailsCoordinator: DetailsCoordinatorProtocol {
    
    // MARK: - Outputs
    enum Output: CoordinatorOutput {
        case didAddPokemon
        case didRemovePokemon
    }
    
    // MARK: - Dependencies
    internal var router: RouterProtocol
    
    // MARK: - Properties
    weak internal var delegate: CoordinatorDelegate?
    internal var childCoordinators: [String : Coordinator] = [:]
    internal weak var parentCoordinator: Coordinator?
    internal var context: CoordinatorContext? // This is a struct
    
    // MARK: - Init
    required init(router: RouterProtocol) {
        self.router = router
    }
    
    // MARK: - PokemonDetailsViewControllerActionsDelegate
    func didAddFavorite(_ pokemon: Pokemon) {
        let outputToSend: DetailsCoordinator.Output = .didAddPokemon
        sendOutputToParent(outputToSend)
    }
    
    func didRemoveFavorite(_ pokemon: Pokemon) {
        let outputToSend: DetailsCoordinator.Output = .didRemovePokemon
        sendOutputToParent(outputToSend)
    }
    
}
