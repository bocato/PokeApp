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
        let tabBarCoordinator = TabBarCoordinator(router: router)
        let viewModel = TabBarViewModel(actionsDelegate: tabBarCoordinator)
        let controller = TabBarViewController.newInstanceFromStoryboard(viewModel: viewModel)
        addChildCoordinator(tabBarCoordinator)
        router.setRootModule(controller, hideBar: true)
        loadRemoteConfigs() // Review this...
    }
    
    private func loadRemoteConfigs() {
        RemoteConfigs.shared.fetchConfigs(success: {
            debugPrint("RemoteConfigs loaded")
        }, failure: { error in
            debugPrint("RemoteConfigs.fetchConfigs failed with error: \n\(error?.localizedDescription ?? "Unknown")")
        })
    }
    
}

