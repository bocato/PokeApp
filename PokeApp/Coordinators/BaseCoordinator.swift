//
//  BaseCoordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

class BaseCoordinator: Coordinator {
    
    // MARK - Properties
    var childCoordinators: [Coordinator] = []
    var rootController: UIViewController
    
    // MARK: - Initialization
    init(rootController: UIViewController) {
        self.rootController = rootController
    }
    
    // MARK: - Start
    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    func finish() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
}
