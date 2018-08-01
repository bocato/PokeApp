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

extension CoordinatorDelegate {
    func childCoordinatorDidStart(_ cordinator: Coordinator) {}
    func finish(_ coordinator: Coordinator, output: CoordinatorInfo) {}
    func childCoordinatorDidFinish(_ coordinator: Coordinator) {}
}
