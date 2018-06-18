//
//  Router.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

protocol RouterProtocol: Presentable { // maybe i have to refactor / change this router...
    
    // MARK: - Properties
    var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get }
    
    // MARK: - Present / Dismiss
    func present(_ module: Presentable?, animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    
    // MARK: - Push / Pop
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
    func popModule(animated: Bool)
    
    // MARK: - Modules
    func setRootModule(_ module: Presentable?, hideBar: Bool)
    func popToRootModule(animated: Bool)
    
}

final class Router: NSObject, RouterProtocol {
    
    // MARK: - Properties
    private var completions: [UIViewController : () -> Void]
    public let navigationController: UINavigationController
    
    // MARK: - Computed Properties
    public var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }
    
    public var hasRootController: Bool {
        return rootViewController != nil
    }
    
    // MARK: - Initializers
    public init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        self.completions = [:]
        super.init()
        self.navigationController.delegate = self
    }
    
    // MARK: - Present / Dismiss
    func present(_ module: Presentable?, animated: Bool = true) {
        guard let controller = module?.toPresentable() else { return }
        rootViewController?.present(controller, animated: animated, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)? = nil) {
        rootViewController?.dismiss(animated: animated, completion: completion)
    }
    
    // MARK: - Push / Pop
    func push(_ module: Presentable?, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard
            let controller = module?.toPresentable(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        navigationController.pushViewController(controller, animated: animated)
    }
    
    func popModule(animated: Bool = true)  {
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool = false) {
        guard let controller = module?.toPresentable() else { return }
        navigationController.setViewControllers([controller], animated: false)
        navigationController.isNavigationBarHidden = hideBar
    }
    
    func popToRootModule(animated: Bool = true) {
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
    
    // MARK: - Helpers
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
    // MARK: Presentable
    func toPresentable() -> UIViewController? {
        return navigationController
    }
    
}

extension Router: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        // Ensure the view controller is popping
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(poppedViewController) else {
                return
        }
        
        runCompletion(for: poppedViewController)
    }
    
}
