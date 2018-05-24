//
//  AppCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

fileprivate enum LaunchInstructor {
    
    case resourceLoader, tabBar
    
    static func configure(showResourceLoader: Bool = false) -> LaunchInstructor {
        if !showResourceLoader {
            return .tabBar
        }
        return .resourceLoader
    }
    
}

final class AppCoordinator: RootCoordinatorProtocol {
    
    // MARK: - Coordinator Properties
    var childCoordinators: [Coordinator] = []
    var rootController: UIViewController?
    var window: UIWindow?
    
    // MARK: - Properties
    private var instructor: LaunchInstructor {
        return LaunchInstructor.configure()
    }
    private var coordinatorFactory: CoordinatorFactoryProtocol = CoordinatorFactory()
    
    // MARK: - Initializers
    init(window: UIWindow?) {
        self.window = window
    }
    
    // MARK: - Start
    func start() {
        let tabBarCoordinator = coordinatorFactory.createTabBarCoordinator()
        addDependency(tabBarCoordinator)
        window?.rootViewController = tabBarCoordinator.rootTabBarController
        window?.makeKeyAndVisible()
    }
    
    
    
}
