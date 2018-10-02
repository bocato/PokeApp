//
//  TabBarModulesFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 11/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

class TabBarModulesFactory: ModuleFactory {
    
    // MARK: Aliases
    typealias ModulesEnum = Modules
    
    // MARK: - ModulesEnum
    enum Modules {
        case home(UINavigationController)
        case favorites(UINavigationController)
    }
    
    // MARK: Builders
    func build(_ module: TabBarModulesFactory.Modules) -> (Coordinator, UIViewController) {
        switch module {
        case .home(let navigationController):
            return buildHomeModule(with: navigationController)
        case .favorites(let navigationController):
            return buildFavoritesModule(with: navigationController)
        }
    }
    
    private func  buildHomeModule(with navigationController: UINavigationController) -> (Coordinator, UIViewController) {
        let router = Router(navigationController: navigationController)
        let homeCoordinator = HomeCoordinator(router: router)
        let services = PokemonService()
        let viewModel = HomeViewModel(actionsDelegate: homeCoordinator, services: services)
        let controller = HomeViewController.newInstanceFromStoryboard(viewModel: viewModel)
        return (homeCoordinator, controller)
    }
    
    private func buildFavoritesModule(with navigationController: UINavigationController) -> (Coordinator, UIViewController) {
        let router = Router(navigationController: navigationController)
        let favoritesCoordinator = FavoritesCoordinator(router: router)
        // let services = PokemonService() // TODO: Inject persistence services
        let viewModel = FavoritesViewModel(actionsDelegate: favoritesCoordinator) // TODO: Inject Services
        let controller = FavoritesViewController.newInstanceFromStoryboard(viewModel: viewModel)
        return (favoritesCoordinator, controller)
    }
    
}

