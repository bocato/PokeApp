//
//  DetailsCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 08/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

struct DetailsCoordinatorInfo: CoordinatorInfo {
    var pokemon: Pokemon!
}

protocol DetailsCoordinatorProtocol: Coordinator {}

class DetailsCoordinator: DetailsCoordinatorProtocol {
    
    // MARK: - Dependencies
    internal(set) var router: RouterProtocol
    internal(set) var delegate: CoordinatorDelegate?
    
    // MARK: - Properties
    var childCoordinators: [String : Coordinator] = [:]
    var parentCoordinator: Coordinator?
    internal(set) var identifier: String = "DetailsCoordinator"
    
    // MARK: - Initialization
    required init(router: RouterProtocol) {
        self.router = router
    }
    
}

extension DetailsCoordinator: PokemonDetailsViewControllerActionsDelegate {
    
    func didAddFavorite(pokemon: Pokemon) {
        let alertController = UIAlertController(title: "Favorite", message: "\(pokemon.name ?? "Pokemon") added as favorite!", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            let output = DetailsCoordinatorInfo(pokemon: pokemon)
            self.delegate?.finish(self, output: output)
        }
        alertController.addAction(action)
        router.present(alertController, animated: true)
    }
    
}
