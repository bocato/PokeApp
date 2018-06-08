//
//  TabBarCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarCoordinatorProtocol:  Coordinator & TabBarViewControllerActionsDelegate {}

class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorProtocol {
    
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
                    let router = Router(rootController: navigationController)
                    let homeCoordinator = HomeCoordinator(router: router)
                    let services = PokemonService()
                    let viewModel = HomeViewModel(actionsDelegate: homeCoordinator, services: services)
                    let controller = HomeViewController.newInstanceFromStoryboard(viewModel: viewModel)
                    self.addChildCoordinator(homeCoordinator)
                    router.setRootModule(controller)
                    homeCoordinator.start()
                case .favorites:
                    let router = Router(rootController: navigationController)
                    let favoritesCoordinator = FavoritesCoordinator(router: router)
                    // let services = PokemonService() // TODO: Inject persistence services
                    let viewModel = FavoritesViewModel(actionsDelegate: favoritesCoordinator) // TODO: Inject Services
                    let controller = FavoritesViewController.newInstanceFromStoryboard(viewModel: viewModel)
                    self.addChildCoordinator(favoritesCoordinator)
                    router.setRootModule(controller)
                    favoritesCoordinator.start()
                }
            }
        }
        
    }
    
}
