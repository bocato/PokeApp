//
//  BaseCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

class BaseCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var router: RouterProtocol
    var childCoordinators: [String : Coordinator] = [ : ]
    
    // MARK: - Intialization
    required init(router: RouterProtocol) {
        self.router = router
    }
    
    // MARK: - Start
    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    // MARK: - Helper Methods
    func addChildCoordinator(_ coordinator: Coordinator) {
        if let child = childCoordinators[identifier], child === coordinator {
            return
        }
        childCoordinators[coordinator.identifier] = coordinator
        debugPrint("\(coordinator.identifier) added")
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        if let coordinatorToRemove = childCoordinators[coordinator.identifier], coordinator === coordinatorToRemove {
            childCoordinators.removeValue(forKey: coordinator.identifier)
            debugPrint("\(coordinator.identifier) removed")
        }
    }
    
}

extension Finishable where Self: BaseCoordinator {
    
    init(router: RouterProtocol, finishClosure: @escaping OutputClosure) {
        self.init(router: router)
        self.finish = finishClosure
    }
    
}



