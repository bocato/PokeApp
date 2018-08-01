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

class AppCoordinator: Coordinator {
    
    // MARK: - Dependencies
    private var instructor: LaunchInstructor {
        return LaunchInstructor.getApplicationStartPoint()
    }
    internal(set) var router: RouterProtocol
    var delegate: CoordinatorDelegate?
    
    // MARK: - Properties
    internal(set) var childCoordinators: [String : Coordinator] = [:]
    internal(set) var parentCoordinator: Coordinator? = nil
    internal(set) var identifier: String = "AppCoordinator"
   
    // MARK: - Initialization
    init(router: RouterProtocol) {
        self.router = router
    }
    
    // MARK: - Start
    func start() {
        switch instructor {
        case .tabBar:
            runMainFlow()
        case .resourceLoader:
            debugPrint("Not implemented")
        }
    }
    
    // MARK: - Flows
    private func runMainFlow() {
        let tabBarCoordinator = TabBarCoordinator(router: router)
        let viewModel = TabBarViewModel(actionsDelegate: tabBarCoordinator)
        let controller = TabBarViewController.newInstanceFromStoryboard(viewModel: viewModel)
        addChildCoordinator(tabBarCoordinator)
        router.setRootModule(controller, hideBar: true)
        tabBarCoordinator.start()
    }
    
}

