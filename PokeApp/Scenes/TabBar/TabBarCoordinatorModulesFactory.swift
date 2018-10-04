//
//  TabBarCoordinatorModulesFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 11/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

class TabBarCoordinatorModulesFactory: ModuleFactory {
    
    // MARK: Aliases
    typealias ModulesEnum = Modules
    
    // MARK: - ModulesEnum
    enum Modules {
        case home(UINavigationController)
        case favorites(UINavigationController)
    }
    
    // MARK: Builders
    func build(_ module: TabBarCoordinatorModulesFactory.Modules) -> (Coordinator, UIViewController) {
        switch module {
        case .home(let navigationController):
            return buildHomeModule(with: navigationController)
        case .favorites(let navigationController):
            return buildFavoritesModule(with: navigationController)
        }
    }
    
    private func  buildHomeModule(with navigationController: UINavigationController) -> (Coordinator, UIViewController) {
        let router = Router(navigationController: navigationController)
        let homeCoordinatorModulesFactory = HomeCoordinatorModulesFactory()
        let homeCoordinator = HomeCoordinator(router: router, favoritesManager: SimpleFavoritesManager.shared, modulesFactory: homeCoordinatorModulesFactory)
        let services = PokemonService()
        let viewModel = HomeViewModel(actionsDelegate: homeCoordinator, services: services)
        let controller = HomeViewController.newInstance(fromStoryboard: .home, viewModel: viewModel)
        return (homeCoordinator, controller)
    }
    
    private func buildFavoritesModule(with navigationController: UINavigationController) -> (Coordinator, UIViewController) {
        let router = Router(navigationController: navigationController)
        let favoritesCoordinatorModulesFactory = FavoritesCoordinatorModulesFactory()
        let favoritesManager = SimpleFavoritesManager.shared
        let favoritesCoordinator = FavoritesCoordinator(router: router, modulesFactory: favoritesCoordinatorModulesFactory, favoritesManager: favoritesManager)
        let viewModel = FavoritesViewModel(actionsDelegate: favoritesCoordinator, favoritesManager: favoritesManager)
        let controller = FavoritesViewController.newInstance(fromStoryboard: .favorites, viewModel: viewModel)
        return (favoritesCoordinator, controller)
    }
    
}

