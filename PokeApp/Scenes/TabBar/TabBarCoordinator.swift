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

class TabBarCoordinator: TabBarCoordinatorProtocol {
    
    // MARK: - Dependencies
    private(set) var modulesFactory: TabBarModulesFactoryProtocol = TabBarModulesFactory()
    internal(set) var router: RouterProtocol
    internal(set) var delegate: CoordinatorDelegate?
    
    // MARK: - Properties
    internal(set) var childCoordinators: [String : Coordinator] = [:]
    internal(set) var parentCoordinator: Coordinator?
    internal(set) var identifier: String = "TabBarCoordinator"
    
    // MARK: - Initialization
    required init(router: RouterProtocol) {
        self.router = router
    }
    
}

extension TabBarCoordinator : TabBarViewControllerActionsDelegate {
    
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
