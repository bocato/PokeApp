//
//  ModuleFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 11/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

protocol ModuleFactoryProtocol {
    
    // MARK: - Associated Types
    associatedtype StoreType
    
    // MARK: - Dependencies
    var store: StoreType? { get set }
    
}

class BaseModuleFactory<T> {
    
    // MARK: - Associated Types
    typealias StoreType = T
    
    // MARK: - Dependencies
    var store: T?
    
    // MARK: - Initialization
    required init(store: T) {
        self.store = store
    }
    
}

