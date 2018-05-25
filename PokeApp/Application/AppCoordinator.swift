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
    var rootController: UIViewController {
        guard let rootViewController = window?.rootViewController else { return UIViewController() }
        return rootViewController
    }
    var window: UIWindow?
    
    // MARK: - Properties
    private var launchInstructor: LaunchInstructor {
        return LaunchInstructor.configure()
    }
    private var coordinatorFactory: CoordinatorFactoryProtocol = CoordinatorFactory()
    
    // MARK: - Initializers
    init(window: UIWindow?) {
        self.window = window
    }
    
    // MARK: - Start
    func start() {
        
        var rootController: UIViewController?
        
        switch launchInstructor {
            case .tabBar:
                let tabBarCoordinator = coordinatorFactory.createTabBarCoordinator()
                addChildCoordinator(tabBarCoordinator)
                rootController = tabBarCoordinator.rootTabBarController
            default:
                return
        }
        
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }
    
}
