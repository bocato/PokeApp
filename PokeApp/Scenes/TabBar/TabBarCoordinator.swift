//
//  TabBarCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarCoordinatorInteractorProtocol: class {
    var onViewDidLoad: ((UINavigationController) -> ())? { get set }
    var onFavoritesSelected: ((UINavigationController) -> ())? { get set }
    var onPokemonsSelected: ((UINavigationController) -> ())? { get set }
}

class TabBarCoordinator: BaseCoordinator {
    
    // MARK: - Start
    override func start() {
        guard let pokeAppTabBarController = rootController as? PokeAppTabBarController else { return }
        pokeAppTabBarController.onViewDidLoad = onFavoritesSelected()
        pokeAppTabBarController.onFavoritesSelected = onFavoritesSelected()
        pokeAppTabBarController.onPokemonsSelected = onPokemonsSelected()
    }
    
    func onFavoritesSelected() -> ((UINavigationController) -> ()) {
        return { navController in
            if navController.viewControllers.isEmpty == true {
                let favoritesCoordinator = CoordinatorFactory().createFavoritesCoordinator()
                favoritesCoordinator.start()
                self.addChildCoordinator(favoritesCoordinator)
            }
        }
    }
    
    func onPokemonsSelected() -> ((UINavigationController) -> ()) {
        return { navController in
            if navController.viewControllers.isEmpty == true {
                let homeCoordinator = CoordinatorFactory().createHomeCoordinator()
                homeCoordinator.start()
                self.addChildCoordinator(homeCoordinator)
            }
        }
    }
    
}
