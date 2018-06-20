//
//  TabBarModulesFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 11/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

protocol TabBarModuleFactoryProtocol {
    
    // MARK: - Builders
    func buildHomeModule(with navigationController: UINavigationController) -> (coordinator: HomeCoordinatorProtocol, controller: HomeViewController)
    func buildFavoritesModule(with navigationController: UINavigationController) -> (coordinator: FavoritesCoordinatorProtocol, controller: FavoritesViewController)
    
}

class TabBarModuleFactory: TabBarModuleFactoryProtocol {
    
    // MARK: - Builders
    func buildHomeModule(with navigationController: UINavigationController) -> (coordinator: HomeCoordinatorProtocol, controller: HomeViewController) {
        let router = Router(navigationController: navigationController)
        let homeCoordinator = HomeCoordinator(router: router)
        let services = PokemonService()
        let viewModel = HomeViewModel(actionsDelegate: homeCoordinator, services: services)
        let controller = HomeViewController.newInstanceFromStoryboard(viewModel: viewModel)
        return (homeCoordinator, controller)
    }
    
    func buildFavoritesModule(with navigationController: UINavigationController) -> (coordinator: FavoritesCoordinatorProtocol, controller: FavoritesViewController) {
        let router = Router(navigationController: navigationController)
        let favoritesCoordinator = FavoritesCoordinator(router: router)
        // let services = PokemonService() // TODO: Inject persistence services
        let viewModel = FavoritesViewModel(actionsDelegate: favoritesCoordinator) // TODO: Inject Services
        let controller = FavoritesViewController.newInstanceFromStoryboard(viewModel: viewModel)
        return (favoritesCoordinator, controller)
    }
    
}


