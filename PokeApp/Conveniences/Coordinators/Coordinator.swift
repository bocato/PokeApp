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
protocol CoordinatorDelegate: class {
//    func childCoordinatorDidStart(_ cordinator: Coordinator)
//    func childCoordinatorDidFinish(_ coordinator: Coordinator)
    func receiveOutput(_ output: CoordinatorOutput, fromCoordinator coordinator: Coordinator)
}

protocol Coordinator: class {
    
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
