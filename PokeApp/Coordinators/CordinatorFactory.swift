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
    
    func createTabBarCoordinator() -> (configurator: Coordinator, presentable: Presentable)
    func createHomeCoordinator(router: Router) -> (configurator: Coordinator, presentable: Presentable)
    
}


class CoordinatorFactory: CoordinatorFactoryProtocol {
    
    func createTabBarCoordinator() -> (configurator: Coordinator, presentable: Presentable) {
        let controller = TabBarViewController.instantiate(viewControllerOfType: TabBarViewController.self, storyboardName: "TabBar")
        let coordinator = TabBarCoordinator(tabBarViewActions: controller, coordinatorFactory: CoordinatorFactory())
        return (coordinator, controller)
    }
    
    func createHomeCoordinator(router: Router) -> (configurator: Coordinator, presentable: Presentable) {
        let controler = HomeViewController.instantiate(viewControllerOfType: HomeViewController.self, storyboardName: "Home")
        let coordinator = HomeCoordinator(router: router, coordinatorFactory: CoordinatorFactory())
        return (coordinator, controler)
    }
    
}
