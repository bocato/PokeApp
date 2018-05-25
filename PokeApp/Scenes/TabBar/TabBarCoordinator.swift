//
//  TabBarCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarViewActions: class {
    var onViewDidLoad: ((UINavigationController) -> ())? { get set }
    var onFavoritesFlowSelect: ((UINavigationController) -> ())? { get set }
    var onHomeFlowSelect: ((UINavigationController) -> ())? { get set }
}

class TabBarCoordinator: BaseCoordinator {
    
    // MARK: - Dependencies
    private let tabBarViewActions: TabBarViewActions
    private let coordinatorFactory: CoordinatorFactoryProtocol
    
    // MARK: - Initialization
    init(tabBarViewActions: TabBarViewActions, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.tabBarViewActions = tabBarViewActions
        self.coordinatorFactory = coordinatorFactory
    }
    
    // MARK: - Start
    override func start() {
        tabBarViewActions.onViewDidLoad = runHomeFlow()
        tabBarViewActions.onHomeFlowSelect = runHomeFlow()
        tabBarViewActions.onFavoritesFlowSelect = runFavoritesFlow()
    }
    
    // MARK: - Flows
    private func runHomeFlow() -> ((UINavigationController) -> ()) {
        return { navigationController in
            if navigationController.viewControllers.isEmpty == true {
                let router = Router(rootController: navigationController)
                let homeCoordinator = HomeCoordinator(router: router, coordinatorFactory: self.coordinatorFactory)
                homeCoordinator.start()
                self.addChildCoordinator(homeCoordinator)
            }
        }
    }
    
    private func runFavoritesFlow() -> ((UINavigationController) -> ()) {
        return { navigationController in
            if navigationController.viewControllers.isEmpty == true {
                //                let  // TODO: Create FavoritesCoordinator
            }
        }
    }
    
}
