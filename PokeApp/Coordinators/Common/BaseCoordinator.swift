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
    var rootController: UIViewController?
    
    // MARK: - Initializers
    init(rootController: UIViewController?) {
        self.rootController = rootController
    }
    
    // MARK: - Start
    func start() {
        fatalError("This NEEDS TO BE overriden!")
    }
    
}
