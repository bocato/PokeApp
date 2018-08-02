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

class TabBarCoordinator: BaseCoordinator {
    
    // MARK: - Dependencies
    private(set) var modulesFactory: TabBarModulesFactoryProtocol = TabBarModulesFactory()
    
    // MARK: - Outputs
    override func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
        switch (child, output) {
        case let (favoritesCoordinator as FavoritesCoordinator, output as FavoritesCoordinator.Output):
            self.delegate?.receiveOutput(output, fromCoordinator: favoritesCoordinator)
        case let (homeCoordinator as HomeCoordinator, output as HomeCoordinator.Output):
            self.delegate?.receiveOutput(output, fromCoordinator: homeCoordinator)
        default: break
        }
    }
    
}

extension TabBarCoordinator: TabBarViewControllerActionsDelegate {
    
    // MARK: - TabBarViewControllerActionsDelegate
    func actOnSelectedTab(_ selectedTab: TabBarViewModel.TabIndex, _ navigationController: UINavigationController) {
        if navigationController.viewControllers.isEmpty {
            switch selectedTab {
            case .home:
                let (coordinator, controller) = self.modulesFactory.buildHomeModule(with: navigationController)
                self.addChildCoordinator(coordinator)
                coordinator.router.setRootModule(controller)
            case .favorites:
                let (coordinator, controller) = self.modulesFactory.buildFavoritesModule(with: navigationController)
                self.delegate = controller.viewModel as? CoordinatorDelegate // this is so we can send a message to the viewmodel from the coordinator
                self.addChildCoordinator(coordinator)
                coordinator.router.setRootModule(controller)
            }
        }
    }
    
}
