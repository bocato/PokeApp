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
    func addChildCoordinator(_ coordinator: Coordinator) {
        if let child = childCoordinators[coordinator.identifier], child === coordinator {
            return
        }
        coordinator.parentCoordinator = self
        childCoordinators[coordinator.identifier] = coordinator
        coordinator.start()
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        if let coordinatorToRemove = childCoordinators[coordinator.identifier], coordinator === coordinatorToRemove {
            childCoordinators.removeValue(forKey: coordinator.identifier)
            coordinatorToRemove.finish()
        }
    }
    
    func sendOutputToParent(_ output: CoordinatorOutput) {
        parentCoordinator?.receiveChildOutput(child: self, output: output)
    }
    
    func receiveChildOutput(child: Coordinator, output: CoordinatorOutput) {
        parentCoordinator?.receiveChildOutput(child: child, output: output)
    }
    
}
