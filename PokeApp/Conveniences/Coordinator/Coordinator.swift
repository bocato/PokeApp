//
//  Coordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorInput {}
protocol CoordinatorOutput {}
protocol CoordinatorContext {}
protocol CoordinatorRoutes {}
protocol CoordinatorDelegate: AnyObject {
//    func childCoordinatorDidStart(_ cordinator: Coordinator)
//    func childCoordinatorDidFinish(_ coordinator: Coordinator)
    func receiveOutput(_ output: CoordinatorOutput, fromCoordinator coordinator: Coordinator)
}

protocol Coordinator: AnyObject {
    
    // MARK: - Dependencies
    var router: RouterProtocol { get set }
    var delegate: CoordinatorDelegate? { get set }
    
    // MARK: - Properties
    var childCoordinators: [String: Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    var context: CoordinatorContext? { get set }
    
    // MARK: Functions
    func start()
    func finish()
    func sendOutputToParent(_ output: CoordinatorOutput)
    func receiveChildOutput(child: Coordinator, output: CoordinatorOutput)
    
}

extension Coordinator {
    var identifier: String {
        return String(describing: type(of: self))
    }
}

extension Coordinator {
    
    // MARK: - Helper Methods
    @discardableResult
    func addChildCoordinator(_ coordinator: Coordinator) -> Bool {
        if let child = childCoordinators[coordinator.identifier], child === coordinator {
            return false
        }
        coordinator.parentCoordinator = self
        childCoordinators[coordinator.identifier] = coordinator
        coordinator.start()
        return true
    }
    
    @discardableResult
    func removeChildCoordinator(_ coordinator: Coordinator?) -> Bool {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else {
            return false
        }
        if let coordinatorToRemove = childCoordinators[coordinator.identifier], coordinator === coordinatorToRemove {
            childCoordinators.removeValue(forKey: coordinator.identifier)
            coordinatorToRemove.finish()
            return true
        }
        return false
    }
    
    func sendOutputToParent(_ output: CoordinatorOutput) {
        parentCoordinator?.receiveChildOutput(child: self, output: output)
    }
    
    func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
        parentCoordinator?.receiveChildOutput(child: child, output: output)
    }
    
}
