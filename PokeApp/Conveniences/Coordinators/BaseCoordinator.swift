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
    
    // MARK: - Functions
    func start() {
        delegate?.childCoordinatorDidStart(self)
    }
    
    func finish() {
        delegate?.childCoordinatorDidFinish(self)
    }
    
    // MARK: - Helper Methods
    func addChildCoordinator(_ coordinator: Coordinator) {
        if let child = childCoordinators[identifier], child === coordinator {
            return
        }
        coordinator.parentCoordinator = self
        coordinator.delegate = self
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
    
    func sendOutput(_ output: CoordinatorInfo) {
        parentCoordinator?.receiveChildOutput(child: self, output: output)
    }
    
    func receiveChildOutput(child: Coordinator, output: CoordinatorInfo) {
        parentCoordinator?.receiveChildOutput(child: child, output: output)
    }
    
}
