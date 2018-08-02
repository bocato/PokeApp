//
//  Coordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorOutput {}
protocol CoordinatorRoutes {}
protocol CoordinatorDelegate {
    func childCoordinatorDidStart(_ cordinator: Coordinator)
    func childCoordinatorDidFinish(_ coordinator: Coordinator)
}

protocol Coordinator: class, CoordinatorDelegate {
    
    // MARK: - Dependencies
    var router: RouterProtocol { get set }
    var delegate: CoordinatorDelegate? { get set }
    
    // MARK: - Properties
    var childCoordinators: [String: Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    
    // MARK: Functions
    func start()
    func finish()
    func sendOutput(_ output: CoordinatorOutput)
    func receiveChildOutput(child: Coordinator, output: CoordinatorOutput)
    
}

extension Coordinator {
    var identifier: String {
        return String(describing: type(of: self))
    }
}

extension CoordinatorDelegate {
    
    func childCoordinatorDidStart(_ cordinator: Coordinator) {
        debugPrint("\(cordinator.identifier) did start")
    }
    
    func childCoordinatorDidFinish(_ coordinator: Coordinator) {
        debugPrint("\(coordinator.identifier) did finish")
    }
    
}
