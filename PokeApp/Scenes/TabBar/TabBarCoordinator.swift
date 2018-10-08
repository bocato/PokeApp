//
//  TabBarCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

class TabBarCoordinator: Coordinator {
    
    // MARK: - Dependencies
    internal(set) var router: RouterProtocol
    weak internal(set) var delegate: CoordinatorDelegate?
    private(set) var modulesFactory: TabBarCoordinatorModulesFactory
    
    // MARK: - Properties
    internal(set) var childCoordinators: [String : Coordinator] = [:]
    internal(set) weak var parentCoordinator: Coordinator? = nil
    internal(set) var context: CoordinatorContext? // This is a struct
    
    // MARK: - Initialization
    init(router: RouterProtocol, modulesFactory: TabBarCoordinatorModulesFactory) {
        self.modulesFactory = modulesFactory
        self.router = router
    }
    
    // MARK: - Start / Finish
    func start() {
        debugPrint("Not needed.")
    }
    
    func finish() {
        debugPrint("Not needed.")
    }
    
    // MARK: - Outputs
    func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
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
                let (coordinator, controller) = modulesFactory.build(.home(navigationController))
                self.addChildCoordinator(coordinator)
                coordinator.router.setRootModule(controller)
            case .favorites:
                let (coordinator, controller) = modulesFactory.build(.favorites(navigationController))
                delegate = (controller as? FavoritesViewController)?.viewModel // this way weh can send a message to the viewmodel from the coordinator
                addChildCoordinator(coordinator)
                coordinator.router.setRootModule(controller)
            }
        }
    }
    
}
