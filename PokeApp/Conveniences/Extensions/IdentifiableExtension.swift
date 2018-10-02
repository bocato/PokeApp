//
//  IdentifiableExtension.swift
//  PokeApp
//
//  Created by Eduardo Bocato on 02/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

protocol Identifiable {
    static var identifier: String { get }
}
extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView: Identifiable {}
