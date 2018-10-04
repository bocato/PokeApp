//
//  AppCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

fileprivate var showResourceLoader = false

fileprivate enum LaunchInstructor {
    
    case resourceLoader, tabBar
    
    static func getApplicationStartPoint(showResourcesLoader: Bool = showResourceLoader) -> LaunchInstructor {
        if !showResourcesLoader {
            return .tabBar
        }
        return .resourceLoader
    }
    
}

class AppCoordinator: BaseCoordinator {
    
    // MARK: - Dependencies
    private var instructor: LaunchInstructor {
        return LaunchInstructor.getApplicationStartPoint()
    }
    private lazy var modulesFactory: AppCoordinatorModulesFactory = AppCoordinatorModulesFactory()
    
    // MARK: - Init
    static func build(window: UIWindow?) -> AppCoordinator? {
        guard let window = window, let rootController = window.rootViewController as? UINavigationController else { return nil }
        let router = Router(navigationController: rootController)
        return AppCoordinator(router: router)
    }
    
    // MARK: - Start
    override func start() {
        switch instructor {
        case .tabBar:
            runMainFlow()
        case .resourceLoader:
            debugPrint("Not implemented.")
        }
    }
    
    // MARK: - Flows
    private func runMainFlow() {
        let (tabBarCoordinator, tabBarController) = modulesFactory.build(.tabBar(router: router))
        addChildCoordinator(tabBarCoordinator)
        router.setRootModule(tabBarController, hideBar: true)
    }
    
}

