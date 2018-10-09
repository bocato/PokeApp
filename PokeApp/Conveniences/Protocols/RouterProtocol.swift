//
//  RouterProtocol.swift
//  PokeApp
//
//  Created by Eduardo Bocato on 09/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

protocol RouterProtocol: class, Presentable { // As basic as possible for now...
    
    // MARK: - Properties
    var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get }
    
    // MARK: - Present / Dismiss
    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)
    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?) // this completion block runs when the viewcontroller is being dismissed
    
    // MARK: - Push / Pop
    func push(_ module: Presentable?)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) // this completion block runs when the viewcontroller is beeing popped
    func popModule()
    func popModule(animated: Bool)
    
    // MARK: - Modules
    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)
    func popToRootModule(animated: Bool)
    
}
