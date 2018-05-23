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
    
    // MARK: X Button Configuration
    func configureXButtonOnRightBarButtonItem() {
        if let _ = navigationController {
            navigationItem.hidesBackButton = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(xButtonDidReceiveTouchUpInside(_:)))
        }
    }
    
    @objc private func xButtonDidReceiveTouchUpInside(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
