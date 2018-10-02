//
//  ModulesFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 11/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

protocol ModuleFactory {
    associatedtype ModulesEnum
    func build(_ module: ModulesEnum) -> (Coordinator, UIViewController)
}


//// IDEA WITH DATA STORE...
//protocol ModulesFactoryProtocol {
//
//    // MARK: - Associated Types
//    associatedtype StoreType
//
//    // MARK: - Dependencies
//    var store: StoreType? { get set }
//
//}

//class BaseModulesFactory<T> {
//
//    // MARK: - Associated Types
//    typealias StoreType = T
//
//    // MARK: - Dependencies
//    var store: T?
//
//    // MARK: - Initialization
//    init(store: T) {
//        self.store = store
//    }
//
//}
