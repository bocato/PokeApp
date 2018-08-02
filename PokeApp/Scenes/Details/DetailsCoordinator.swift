//
//  DetailsCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 08/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

protocol DetailsCoordinatorProtocol: Coordinator, PokemonDetailsViewControllerActionsDelegate {}

class DetailsCoordinator: BaseCoordinator, DetailsCoordinatorProtocol {
    
    enum Output: CoordinatorOutput {
        case didAddPokemon(Pokemon)
        case didRemovePokemon(Pokemon)
    }
    
}

extension DetailsCoordinator: PokemonDetailsViewControllerActionsDelegate {
    
    func didAddFavorite(pokemon: Pokemon) {
        let output: DetailsCoordinator.Output = .didAddPokemon(pokemon)
        self.sendOutput(output)
    }
    
    func didRemoveFavorite(pokemon: Pokemon) {
        let output: DetailsCoordinator.Output = .didRemovePokemon(pokemon)
        self.sendOutput(output)
    }
    
}
