//
//  AppDelegate.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var applicationCoordinator: Coordinator? = makeAppCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupApplication()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

private extension AppDelegate {
    
    var rootController: UINavigationController {
        return self.window!.rootViewController as! UINavigationController
    }
    
    func setupApplication() {
        if isRunningTests {
            window = UIWindow()
            window?.rootViewController = UIViewController()
            window?.makeKeyAndVisible()
        } else {
            // Start App Coordinator
            applicationCoordinator?.start()
            // Start Firebase
            FirebaseApp.configure()
        }
    }
    
    private func makeAppCoordinator() -> Coordinator? {
        return AppCoordinator.build(window: window)
    }
    
}

private extension AppDelegate {
    var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil // this means that we are running unit tests
    }
}

