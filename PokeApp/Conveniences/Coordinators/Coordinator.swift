//
//  Coordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorInfo {}
protocol CoordinatorDelegate {
    func childCoordinatorDidStart(_ cordinator: Coordinator)
    func finish(_ coordinator: Coordinator, output: CoordinatorInfo)
    func childCoordinatorDidFinish(_ coordinator: Coordinator)
}

protocol Coordinator: class, CoordinatorDelegate {
    
    // MARK: - Dependencies
    var router: RouterProtocol { get set }
    var delegate: CoordinatorDelegate? { get set }
    
    // MARK: - Properties
    var identifier: String { get }
    var childCoordinators: [String: Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    
    // MARK: Functions
    func start()
    func finish()
    func receiveChildOutput()
    func sendChildOutput()
    
}

extension Coordinator {
    
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

extension CoordinatorDelegate {
    func childCoordinatorDidStart(_ cordinator: Coordinator) {}
    func finish(_ coordinator: Coordinator, output: CoordinatorInfo) {}
    func childCoordinatorDidFinish(_ coordinator: Coordinator) {}
}
