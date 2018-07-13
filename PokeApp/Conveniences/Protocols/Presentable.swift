//
//  Presentable.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

protocol Presentable {
    func toPresentable() -> UIViewController?
}

extension UIViewController: Presentable {
    
    func toPresentable() -> UIViewController? {
        return self
    }
    
}
