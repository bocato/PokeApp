//
//  UIImage+ProjectResources.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

enum ImageResourceName: String {
    case openPokeball = "open_pokeball"
}

extension UIImage {
    
    static func fromResource(withName name: ImageResourceName) -> UIImage? {
        return UIImage(named: name.rawValue)
    }
    
}
