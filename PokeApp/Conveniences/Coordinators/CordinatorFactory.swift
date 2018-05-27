//
//  CordinatorFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorFactoryProtocol {
    func createTabBarCoordinator(router: RouterProtocol) -> (configurator: Coordinator, presentable: Presentable)
    func createHomeCoordinator(router: RouterProtocol) -> (configurator: Coordinator, presentable: Presentable)
    func createFavoritesCoordinator(router: RouterProtocol) -> (configurator: Coordinator, presentable: Presentable)
}

class CoordinatorFactory: CoordinatorFactoryProtocol {
    
    class func createAppCoordinator(window: UIWindow) -> AppCoordinator {
        let rootController = window.rootViewController as! UINavigationController
        let router = Router(rootController: rootController)
        let coordinatorFactory = CoordinatorFactory() // TODO: Use injection...
        return AppCoordinator(router: router, coordinatorFactory: coordinatorFactory)
    }
    
    func createTabBarCoordinator(router: RouterProtocol) -> (configurator: Coordinator, presentable: Presentable) {
        let coordinatorFactory = CoordinatorFactory() // TODO: Use injection...
        let coordinator = TabBarCoordinator(router: router, coordinatorFactory: coordinatorFactory)
        let viewModel = TabBarViewModel(coordinator: coordinator)
        let controller = TabBarViewController.newInstanceFromStoryboard(viewModel: viewModel)
        return (coordinator, controller)
    }
    
    func createHomeCoordinator(router: RouterProtocol) -> (configurator: Coordinator, presentable: Presentable) {
        let coordinatorFactory = CoordinatorFactory() // TODO: Use injection...
        let coordinator = HomeCoordinator(router: router, coordinatorFactory: coordinatorFactory)
        let services = PokemonService()
        let viewModel = HomeViewModel(coordinator: coordinator, services: services)
        let controller = HomeViewController.newInstanceFromStoryboard(viewModel: viewModel)
        return (coordinator, controller)
    }
    
    func createFavoritesCoordinator(router: RouterProtocol) -> (configurator: Coordinator, presentable: Presentable) {
        let coordinatorFactory = CoordinatorFactory() // TODO: Use injection...
        let coordinator = FavoritesCoordinator(router: router, coordinatorFactory: coordinatorFactory)
        // let services = PokemonService() // TODO: Inject persistence services
        let viewModel = FavoritesViewModel(coordinator: coordinator) // TODO: Inject Services
        let controller = FavoritesViewController.newInstanceFromStoryboard(viewModel: viewModel)
        return (coordinator, controller)
    }
    
}
