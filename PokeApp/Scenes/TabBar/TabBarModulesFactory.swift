//
//  TabBarModulesFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 11/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

protocol TabBarModulesFactoryProtocol {
    
    // MARK: - Builders
    func buildHomeModule(with navigationController: UINavigationController) -> (coordinator: HomeCoordinatorProtocol, controller: HomeViewController)
    func buildFavoritesModule(with navigationController: UINavigationController) -> (coordinator: FavoritesCoordinatorProtocol, controller: FavoritesViewController)
    
}

class TabBarModulesFactory: TabBarModulesFactoryProtocol {
    
    // MARK: - Builders
    func buildHomeModule(with navigationController: UINavigationController) -> (coordinator: HomeCoordinatorProtocol, controller: HomeViewController) {
        let router = Router(navigationController: navigationController)
        let homeCoordinator = HomeCoordinator(router: router)
//        let services = PokemonService()
//        let viewModel = HomeViewModel(actionsDelegate: homeCoordinator, services: services)
        
        let mockURL = URL(string: "http://someurl.com")!
        let mockedURLResponse = HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        let mockedSession = MockedURLSession(data: nil, response: mockedURLResponse, error: nil)
        let mockedNetworkDispatcher = NetworkDispatcher(url: mockURL, session: mockedSession)
        let mockedPokemonServices = PokemonService(dispatcher: mockedNetworkDispatcher)
        let viewModel = HomeViewModel(actionsDelegate: homeCoordinator, services: mockedPokemonServices)
        
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


