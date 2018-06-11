//
//  ModuleFactory.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 11/06/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

protocol ModuleFactoryProtocol {
    
    associatedtype StoreType
    
    // MARK: - Dependencies
    var store: StoreType { get set }
    
}
