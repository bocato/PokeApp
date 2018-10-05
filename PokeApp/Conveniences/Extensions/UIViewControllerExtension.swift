//
//  UIViewControllerExtension.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Instantiation
    class func instantiate<T>(viewControllerOfType type: T.Type, storyboardName: String) -> T {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "\(type)") as! T
    }
    
}
