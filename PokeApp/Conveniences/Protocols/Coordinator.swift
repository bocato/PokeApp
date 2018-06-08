//
//  Coordinator.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    associatedtype CoordinatorDelegate
    var delegate: CoordinatorDelegate { get }
    var router: RouterProtocol { get }
    func start()
}

protocol CoordinatorOutput {
    associatedtype OutputObject
    var finish: ((OutputObject) ->  Void)? { get set }
}
