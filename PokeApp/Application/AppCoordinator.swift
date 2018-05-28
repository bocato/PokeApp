//
//  AppCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

fileprivate var showResourceLoader = false

fileprivate enum LaunchInstructor {
    
    case resourceLoader, tabBar
    
    static func getApplicationStartPoint(showResourceLoader: Bool = showResourceLoader) -> LaunchInstructor {
        if !showResourceLoader {
            return .tabBar
        }
        return .resourceLoader
    }
    
}

final class AppCoordinator: BaseCoordinator {
    
    // MARK: - Dependencies
    private var instructor: LaunchInstructor {
        return LaunchInstructor.getApplicationStartPoint()
    }
    
    // MARK: - Start
    override func start() {
        switch instructor {
        case .tabBar:
            runMainFlow()
        case .resourceLoader:
            debugPrint("Not implemented")
        }
    }
    
    // MARK: - Flows
    private func runMainFlow() {
        let (tabBarCoordinator, tabBarModule) = coordinatorFactory.createTabBarCoordinator(router: router)
        addChildCoordinator(tabBarCoordinator)
        router.setRootModule(tabBarModule, hideBar: true)
        tabBarCoordinator.start()
    }
    
}

