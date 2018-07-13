//
//  DetailsCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 08/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

struct DetailsCoordinatorOutput {
    var pokemkon: Pokemon
}

protocol DetailsCoordinatorProtocol: Coordinator {

    // MARK: Finishable Properties
    var finish: ((_ output: DetailsCoordinatorOutput, _ coordinator: DetailsCoordinatorProtocol) ->  Void)? { get set } // this self needs to be weak and
}

final class DetailsCoordinator: BaseCoordinator, DetailsCoordinatorProtocol {
    
    // MARK: Finishable Properties
    var finish: ((DetailsCoordinatorOutput, DetailsCoordinatorProtocol) -> Void)?
    
    // MARK: Initialization
    convenience init(router: RouterProtocol, flowFinishClosure: ((DetailsCoordinatorOutput, DetailsCoordinatorProtocol) -> Void)?) {
        self.init(router: router)
        self.finish = flowFinishClosure
    }
    
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
            let flowOutput = DetailsCoordinatorOutput(pokemkon: pokemon)
            self.finish?(flowOutput, self)
        }
        alertController.addAction(action)
        router.present(alertController, animated: true)
    }
    
}
