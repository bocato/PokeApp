//
//  AppDelegate.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var applicationCoordinator: Coordinator? = makeAppCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupApplication()
        return true
    }

}

// MARK: - Helper Extensios
private extension AppDelegate {
    
    var rootController: UINavigationController {
        return self.window!.rootViewController as! UINavigationController
    }
    
    func setupApplication() {
        if isRunningUnitTests {
            window = UIWindow()
            window?.rootViewController = UIViewController()
            window?.makeKeyAndVisible()
        } else {
            // Start App Coordinator
            applicationCoordinator?.start()
        }
    }
    
    private func makeAppCoordinator() -> Coordinator? {
        return AppCoordinator.build(window: window)
    }
    
}

private extension AppDelegate {
    var isRunningUnitTests: Bool {
        return ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil // this means that we are running unit tests
    }
}
