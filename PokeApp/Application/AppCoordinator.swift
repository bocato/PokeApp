//
//  AppCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    // MARK: - Enums
    enum LaunchInstructor {
        
        case resourceLoader, tabBar
        
        static func getApplicationStartPoint(showResourcesLoader: Bool) -> LaunchInstructor {
            if !showResourcesLoader {
                return .tabBar
            }
            return .resourceLoader
        }
        
    }
    
    // MARK: - Dependencies
    private(set) var showResourceLoader: Bool
    private(set) var modulesFactory: AppCoordinatorModulesFactory!
    
    // MARK: - Init
    init(router: RouterProtocol, modulesFactory: AppCoordinatorModulesFactory, showResourceLoader: Bool) {
        self.showResourceLoader = showResourceLoader
        self.modulesFactory = modulesFactory
        super.init(router: router)
    }
    
    open class func build(window: UIWindow?, modulesFactory: AppCoordinatorModulesFactory = AppCoordinatorModulesFactory(), showResourceLoader: Bool = false) -> AppCoordinator? {
        guard let window = window, let rootController = window.rootViewController as? UINavigationController else { return nil }
        let router = Router(navigationController: rootController)
        return AppCoordinator(router: router, modulesFactory: modulesFactory, showResourceLoader: showResourceLoader)
    }
    
    // MARK: - Start
    override func start() {
        let appStartPoint = LaunchInstructor.getApplicationStartPoint(showResourcesLoader: showResourceLoader)
        switch appStartPoint {
        case .tabBar:
            runMainFlow()
        case .resourceLoader:
            runResourcesLoaderFlow()
        }
    }
    
    // MARK: - Flows
    private func runMainFlow() {
        let (tabBarCoordinator, tabBarController) = modulesFactory.build(.tabBar(router: router))
        addChildCoordinator(tabBarCoordinator)
        router.setRootModule(tabBarController, hideBar: true)
    }
    
    private func runResourcesLoaderFlow() {
       debugPrint("Not implemented.")
    }
    
}

