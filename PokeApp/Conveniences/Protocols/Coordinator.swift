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
    
    // MARK: - Dependencies
    var router: RouterProtocol { get }
    
    // MARK: Functions
    func start()
    
}

extension Coordinator {
    
    var identifier: String {
        return String(describing: self)
    }
    
}

protocol Finishable {
    associatedtype OutputObject
    typealias OutputClosure = ((_ output: OutputObject, _ coordinator: Self) ->  Void)
    var finish: OutputClosure? { get set } // this self needs to be weak and
}
