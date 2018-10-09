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
