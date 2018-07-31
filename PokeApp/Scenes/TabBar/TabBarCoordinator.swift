//
//  TabBarCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarCoordinatorProtocol: Coordinator & TabBarViewControllerActionsDelegate {
    // MARK: - Dependencies
    var modulesFactory: TabBarModulesFactoryProtocol { get }
}

class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorProtocol {
    
    // MARK: - Dependencies
    internal var modulesFactory: TabBarModulesFactoryProtocol = TabBarModulesFactory()
    
    // MARK: - Start
    override func start() {}
    
    // MARK: - TabBarViewControllerActionsDelegate
    func actOnSelectedTab(_ selectedTab: TabBarViewModel.TabIndex, _ navigationController: UINavigationController) {
        if navigationController.viewControllers.isEmpty {
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
