//
//  DetailsCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 08/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

class DetailsCoordinator: BaseCoordinator {
    
    // MARK: - Outputs
    enum Output: CoordinatorOutput {
        case didAddPokemon
        case didRemovePokemon
    }
    
}

extension DetailsCoordinator: PokemonDetailsViewControllerActionsDelegate {
    
    func didAddFavorite() {
        let outputToSend: DetailsCoordinator.Output = .didAddPokemon
        sendOutputToParent(outputToSend)
    }
    
    func didRemoveFavorite() {
        let outputToSend: DetailsCoordinator.Output = .didRemovePokemon
        sendOutputToParent(outputToSend)
    }
    
}
