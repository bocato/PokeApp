//
//  DetailsCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 08/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

class DetailsCoordinator: Coordinator {
    
    // MARK: - Outputs
    enum Output: CoordinatorOutput {
        case didAddPokemon
        case didRemovePokemon
    }
    
    // MARK: - Dependencies
    internal(set) var router: RouterProtocol
    weak internal(set) var delegate: CoordinatorDelegate?
    
    // MARK: - Properties
    internal(set) var childCoordinators: [String : Coordinator] = [:]
    internal(set) weak var parentCoordinator: Coordinator? = nil
    internal(set) var context: CoordinatorContext? // This is a struct
    
    // MARK: - Init
    init(router: RouterProtocol) {
        self.router = router
    }
    
    // MARK: - Start / Finish
    func start() {
        debugPrint("Not needed.")
    }
    
    func finish() {
        debugPrint("Not needed.")
    }
    
}

extension DetailsCoordinator: PokemonDetailsViewControllerActionsDelegate { // TODO: Channge this... Use, dependency injection.
    
    func didAddFavorite() {
        let outputToSend: DetailsCoordinator.Output = .didAddPokemon
        sendOutputToParent(outputToSend)
    }
    
    func didRemoveFavorite() {
        let outputToSend: DetailsCoordinator.Output = .didRemovePokemon
        sendOutputToParent(outputToSend)
    }
    
}
