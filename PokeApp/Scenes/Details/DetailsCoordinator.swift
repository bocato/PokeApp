//
//  DetailsCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 08/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

final class  DetailsCoordinator: BaseCoordinator & Finishable {
    
    // MARK: Finishable Properties
    typealias OutputObject = Pokemon
    var finish: ((Pokemon, DetailsCoordinator) -> Void)?
    
    // MARK: - Start
    override func start() {
        // Configure something if needed...
    }
    
}

extension DetailsCoordinator: PokemonDetailsViewControllerActionsDelegate {
    
    func didAddFavorite(pokemon: Pokemon) {
        let alertController = UIAlertController(title: "Favorite", message: "\(pokemon.name ?? "Pokemon") added as favorite!", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.router.popModule()
            self.finish?(pokemon, self)
        }
        alertController.addAction(action)
        router.present(alertController, animated: true)
    }
    
}
