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
        case didAddPokemon(Pokemon)
        case didRemovePokemon(Pokemon)
    }
    
}

extension DetailsCoordinator: PokemonDetailsViewControllerActionsDelegate {
    
    func didAddFavorite(pokemon: Pokemon) {
        let outputToSend: DetailsCoordinator.Output = .didAddPokemon(pokemon)
        sendOutputToParent(outputToSend)
    }
    
    func didRemoveFavorite(pokemon: Pokemon) {
        let outputToSend: DetailsCoordinator.Output = .didRemovePokemon(pokemon)
        sendOutputToParent(outputToSend)
    }
    
}
