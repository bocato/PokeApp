//
//  TabBarCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarControllerActions: class {
//    var onViewDidLoad: ((UINavigationController) -> ())? { get set }
//    var onFavoritesFlowSelect: ((UINavigationController) -> ())? { get set }
//    var onHomeFlowSelect: ((UINavigationController) -> ())? { get set }
    
    func onViewDidLoad(navigationController: UINavigationController)
    func onFavoritesFlowSelect(navigationController: UINavigationController)
    func onHomeFlowSelect(navigationController: UINavigationController)
    
}

class TabBarCoordinator: BaseCoordinator {
    
    // MARK: - Dependencies
    private let router: RouterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    
    // MARK: - Initialization
    init(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    // MARK: - Start
    override func start() {
//        tabBarViewActions.onViewDidLoad = runHomeFlow()
//        tabBarViewActions.onHomeFlowSelect = runHomeFlow()
//        tabBarViewActions.onFavoritesFlowSelect = runFavoritesFlow()
    }
    
    // MARK: - Flows
//    private func runHomeFlow() -> ((UINavigationController) -> ()) {
//        return { navigationController in
//            if navigationController.viewControllers.isEmpty == true {
//                let router = Router(rootController: navigationController)
//                let (homeCoordinator, _) = self.coordinatorFactory.createHomeCoordinator(router: router)
//                homeCoordinator.start()
//                self.addChildCoordinator(homeCoordinator)
//            }
//        }
//    }
//
//    private func runFavoritesFlow() -> ((UINavigationController) -> ()) {
//        return { navigationController in
//            if navigationController.viewControllers.isEmpty == true {
//                //                let  // TODO: Create FavoritesCoordinator
//            }
//        }
//    }
    
}

// MARK: - Flows
extension TabBarCoordinator: TabBarControllerActions {
    
    func onViewDidLoad(navigationController: UINavigationController) {
        onHomeFlowSelect(navigationController: navigationController)
    }
    
    func onFavoritesFlowSelect(navigationController: UINavigationController) {
        
    }
    
    func onHomeFlowSelect(navigationController: UINavigationController) {
        if navigationController.viewControllers.isEmpty == true {
            let router = Router(rootController: navigationController)
            let (homeCoordinator, controller) = self.coordinatorFactory.createHomeCoordinator(router: router)
            addChildCoordinator(homeCoordinator)
            router.setRootModule(controller)
            homeCoordinator.start()
        }
    }
    
    
}
