//
//  BaseCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 01/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

class BaseCoordinator: Coordinator {
    
    // MARK: - Dependencies
    internal(set) var router: RouterProtocol
    weak internal(set) var delegate: CoordinatorDelegate?
    
    // MARK: - Properties
    internal(set) var childCoordinators: [String : Coordinator] = [:]
    internal(set) var parentCoordinator: Coordinator? = nil
    internal(set) var context: CoordinatorContext? // This is an struct
    
    // MARK: - Initialization
    init(router: RouterProtocol) {
        self.router = router
    }
    
    // MARK: - Functions
    func start() {
        debugPrint("Override if you need it!")
    }
    
    func finish() { 
        debugPrint("Override if you need it!")
    }
    
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
