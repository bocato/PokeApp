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
        // swiftlint:disable force_cast
        return self.window!.rootViewController as! UINavigationController
    }
    
    func setupApplication() {
    
        UIView.setAnimationsEnabled(!isRunningUITests)
        
        if isRunningUnitTests && !isRunningUITests {
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
    
    var isRunningUITests: Bool {
        var isRunningUITestsEnvironmentVariableValue = false
        if let isRunningUITests = ProcessInfo.processInfo.environment["IS_RUNNING_UI_TESTS"] { // this is injected on the scheme arguments
            isRunningUITestsEnvironmentVariableValue = isRunningUITests == "YES"
        }
        return ProcessInfo.processInfo.arguments.contains("UITestMode") || isRunningUITestsEnvironmentVariableValue
    }
    
}
