//
//  PokeAppTabBarController.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PokeAppTabBarController: UITabBarController {
    
    // MARK: - Properties
    let viewModel = PokeAppTabBarViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

