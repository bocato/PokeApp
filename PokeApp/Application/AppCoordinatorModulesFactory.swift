//
//  AppModulesFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 13/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

class AppCoordinatorModulesFactory: ModuleFactory {
    
    // MARK: Aliases
    typealias ModulesEnum = Module
    
    // MARK: - ModulesEnum
    enum Module {
        case tabBar(router: RouterProtocol)
    }
    
    // MARK: Functions
    func build(_ module: Module) -> (Coordinator, UIViewController) {
        switch module {
        case .tabBar(let router):
            return buildTabBar(router: router)
        }
    }
    
    // MARK: - Builder Methods
    private func buildTabBar(router: RouterProtocol) -> (Coordinator, UIViewController) {
        let tabBarCoordinatorModulesFactory = TabBarCoordinatorModulesFactory()
        let tabBarCoordinator = TabBarCoordinator(router: router, modulesFactory: tabBarCoordinatorModulesFactory)
        let viewModel = TabBarViewModel(actionsDelegate: tabBarCoordinator)
        let controller = TabBarViewController.newInstance(fromStoryboard: .tabBar, viewModel: viewModel)
        return (tabBarCoordinator, controller)
    }
    
}
