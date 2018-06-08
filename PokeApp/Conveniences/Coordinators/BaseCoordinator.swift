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
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Intialization
    init(router: RouterProtocol) {
        self.router = router
    }
    
    // MARK: - Start
    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    // MARK: - Helper Methods
    func addChildCoordinator(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        //        child.delegate = self //TODO: Implementar delegate do pai.
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
}
