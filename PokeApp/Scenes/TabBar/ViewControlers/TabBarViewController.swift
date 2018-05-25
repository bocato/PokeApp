//
//  TabBarViewController.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TabBarViewController: UITabBarController, TabBarViewActions {
    
    // MARK: - TabBarViewActions
    var onViewDidLoad: ((UINavigationController) -> ())?
    var onFavoritesFlowSelect: ((UINavigationController) -> ())?
    var onHomeFlowSelect: ((UINavigationController) -> ())?
    
    // MARK: - Properties
    let viewModel = TabBarViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    // MARK: Setup
    func setupViewController() {
        delegate = self
        if let controller = customizableViewControllers?.first as? UINavigationController {
            onViewDidLoad?(controller)
        }
    }
    
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
        switch selectedIndex {
        case TabBarFlowIndex.homeFlow.rawValue:
            onHomeFlowSelect?(controller)
        case TabBarFlowIndex.favoritesFlow.rawValue:
            onFavoritesFlowSelect?(controller)
        default:
            return
        }
    }
    
}
