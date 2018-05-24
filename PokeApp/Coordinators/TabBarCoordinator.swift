//
//  TabBarCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

class TabBarCoordinator: BaseCoordinator {
    
    override func start() {
        guard let pokeAppTabBarController = rootController as? PokeAppTabBarController else { return }
    }
    
    
    
    private func runItemFlow() -> ((UINavigationController) -> ()) {
        return { navController in
            if navController.viewControllers.isEmpty == true {
                let itemCoordinator = self.coordinatorFactory.makeItemCoordinator(navController: navController)
                itemCoordinator.start()
                self.addDependency(itemCoordinator)
            }
        }
    }
    
    private func runSettingsFlow() -> ((UINavigationController) -> ()) {
        return { navController in
            if navController.viewControllers.isEmpty == true {
                let settingsCoordinator = self.coordinatorFactory.makeSettingsCoordinator(navController: navController)
                settingsCoordinator.start()
                self.addDependency(settingsCoordinator)
            }
        }
    }
    
}
