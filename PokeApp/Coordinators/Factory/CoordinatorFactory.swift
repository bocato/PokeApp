//
//  CoordinatorFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

protocol CoordinatorFactoryProtocol {
    func createTabBarCoordinator() -> TabBarCoordinator
}

class CoordinatorFactory: CoordinatorFactoryProtocol {

    func createTabBarCoordinator() -> TabBarCoordinator { //TODO: modify when routers are added? Inject viewModels?
        let pokeAppTabBarController = PokeAppTabBarController.instantiate(viewControllerOfType: PokeAppTabBarController.self, storyboardName: "TabBar")
        let tabBarCoordinator = TabBarCoordinator(rootController: pokeAppTabBarController)
        return tabBarCoordinator
    }
    
}
