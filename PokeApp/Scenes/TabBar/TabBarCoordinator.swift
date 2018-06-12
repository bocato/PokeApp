//
//  TabBarCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarCoordinatorProtocol:  Coordinator & TabBarViewControllerActionsDelegate {
    
    // MARK: - Dependencies
    var modulesFactory: TabBarModuleFactoryProtocol { get }

}

class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorProtocol {
    
    // MARK: - Dependencies
    internal var modulesFactory: TabBarModuleFactoryProtocol = TabBarModuleFactory(store: TabBarModuleStore())
    
    // MARK: - TabBarControllerActions
    var onTabSelect: ((_ selectedTab: TabBarIndex, _ navigationController: UINavigationController) -> ())?
    
    // MARK: - Start
    override func start() {
        setupActions()
    }
    
    // MARK: - Flows Setup
    func setupActions() {
        
        onTabSelect = { selectedTab, navigationController in
            if navigationController.viewControllers.isEmpty == true {
                switch selectedTab {
                case .home:
                    let (coordinator, controller) = self.modulesFactory.buildHomeModule(with: navigationController)
                    self.addChildCoordinator(coordinator)
                    coordinator.router.setRootModule(controller)
                    coordinator.start()
                case .favorites:
                    let (coordinator, controller) = self.modulesFactory.buildFavoritesModule(with: navigationController)
                    self.addChildCoordinator(coordinator)
                    coordinator.router.setRootModule(controller)
                    coordinator.start()
                }
            }
        }
        
    }
    
}
