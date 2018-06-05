//
//  TabBarCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarControllerActions: class {
    var onFavoritesFlowSelect: ((UINavigationController) -> ())? { get set }
    var onHomeFlowSelect: ((UINavigationController) -> ())? { get set }
}

protocol TabBarCoordinatorProtocol:  Coordinator & TabBarControllerActions {}

class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorProtocol {
    
    // MARK: - TabBarControllerActions
    var onFavoritesFlowSelect: ((UINavigationController) -> ())?
    var onHomeFlowSelect: ((UINavigationController) -> ())?
    
    // MARK: - Start
    override func start() {
        setupFlows()
    }
    
    // MARK: - Flows Setup
    func setupFlows() {
        
        onHomeFlowSelect = { navigationController in
            if navigationController.viewControllers.isEmpty == true {
                let router = Router(rootController: navigationController)
                let homeCoordinator = HomeCoordinator(router: router)
                let services = PokemonService()
                let viewModel = HomeViewModel(coordinator: homeCoordinator, services: services)
                let controller = HomeViewController.newInstanceFromStoryboard(viewModel: viewModel)
                router.setRootModule(controller)
                homeCoordinator.start()
            }
        }
    
        onFavoritesFlowSelect = { navigationController in
            if navigationController.viewControllers.isEmpty == true {
                debugPrint("coisa")
                let router = Router(rootController: navigationController)
                let favoritesCoordinator = FavoritesCoordinator(router: router)
                // let services = PokemonService() // TODO: Inject persistence services
                let viewModel = FavoritesViewModel(coordinator: favoritesCoordinator) // TODO: Inject Services
                let controller = FavoritesViewController.newInstanceFromStoryboard(viewModel: viewModel)
                self.addChildCoordinator(favoritesCoordinator)
                router.setRootModule(controller)
                favoritesCoordinator.start()
            }
        }
        
    }
    
}

// MARK: - Flows with functions
//protocol TabBarControllerActions: class {
//    func onFavoritesFlowSelect(navigationController: UINavigationController)
//    func onHomeFlowSelect(navigationController: UINavigationController)
//}
//
//extension TabBarCoordinator: TabBarControllerActions {
//
//    func onFavoritesFlowSelect(navigationController: UINavigationController) {
//
//    }
//
//    func onHomeFlowSelect(navigationController: UINavigationController) {
//        if navigationController.viewControllers.isEmpty == true {
//            let router = Router(rootController: navigationController)
//            let (homeCoordinator, controller) = self.coordinatorFactory.createHomeCoordinator(router: router)
//            addChildCoordinator(homeCoordinator)
//            router.setRootModule(controller)
//            homeCoordinator.start()
//        }
//    }
//
//}