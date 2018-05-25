//
//  CoordinatorFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

protocol CoordinatorFactoryProtocol {
    func createTabBarCoordinator() -> TabBarCoordinator
    func createFavoritesCoordinator() -> FavoritesCoordinator
    func createHomeCoordinator() -> HomeCoordinator
    func createDetailsCordinator(withPokemonId id: Int) -> DetailsCoordinator
}

class CoordinatorFactory: CoordinatorFactoryProtocol {

    func createTabBarCoordinator() -> TabBarCoordinator { //TODO: modify when routers are added? Inject viewModels?
        let pokeAppTabBarController = PokeAppTabBarController.instantiate(viewControllerOfType: PokeAppTabBarController.self, storyboardName: "TabBar")
        return pokeAppTabBarViewModel.coordinator
    }
    
    func createFavoritesCoordinator() -> FavoritesCoordinator {
        let favoritesViewController = FavoritesViewController.instantiate(viewControllerOfType: FavoritesViewController.self, storyboardName: "Favorites")
        let favoritesCoordinator = FavoritesCoordinator(rootController: favoritesViewController)
        return favoritesCoordinator
    }
    
    func createHomeCoordinator() -> HomeCoordinator {
        let homeViewController = HomeViewController.instantiate(viewControllerOfType: HomeViewController.self, storyboardName: "Home")
        let homeCoordinator = HomeCoordinator(rootController: homeViewController)
        return homeCoordinator
    }
    
    func createDetailsCordinator(withPokemonId id: Int) -> DetailsCoordinator {
        let pokemonDetailsViewController = PokemonDetailsViewController.instantiateNew(withPokemonId: id)
        let detailsCoordinator = DetailsCoordinator(rootController: pokemonDetailsViewController)
        return detailsCoordinator
    }
    
}
