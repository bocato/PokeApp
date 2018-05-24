//
//  Coordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var rootController: UIViewController? { get }
    func start()
}

extension Coordinator {
    
    var rootTabBarController: UITabBarController? {
        guard let tabBarController = rootController as? UITabBarController else { return nil }
        return tabBarController
    }
    
    var rootNavigationController: UINavigationController? {
        guard let navigationController = rootController as? UINavigationController else { return nil }
        return navigationController
    }
    
    func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinator?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
}
