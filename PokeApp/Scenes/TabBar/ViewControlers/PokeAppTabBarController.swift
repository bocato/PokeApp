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

class PokeAppTabBarController: UITabBarController, TabBarCoordinatorInteractorProtocol {
    
    // MARK: - Properties
    let viewModel = PokeAppTabBarViewModel()
    
    // MARK: - TabBarCoordinatorInteractorProtocol
    var onViewDidLoad: ((UINavigationController) -> ())?
    var onFavoritesSelected: ((UINavigationController) -> ())?
    var onPokemonsSelected: ((UINavigationController) -> ())?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        delegate = self
        if let controller = customizableViewControllers?.first as? UINavigationController {
            viewModel.onViewDidLoad?(controller)
        }
    }
    
}

// MARK: - UITabBarControllerDelegate
extension PokeAppTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
        let tabItem = PokeAppTabBarViewModel.TabItem(rawValue: selectedIndex)!
        
    }
    
}
