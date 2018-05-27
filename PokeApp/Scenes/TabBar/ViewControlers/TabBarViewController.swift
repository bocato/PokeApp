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

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    var viewModel: TabBarViewModel!
    
    // MARK: - Instantiation
//    private(set) var viewModel: TabBarViewModel // i can do this only if i use xibs
//    init(viewModel: TabBarViewModel) { // i can do this only if i use xibs
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    //    let viewController = TabBarViewController(viewModel: TabBarViewModel()) // i can do this only if i use xibs
    
    class func newInstanceFromStoryboard(viewModel: TabBarViewModel) ->  TabBarViewController {
        let controller = TabBarViewController.instantiate(viewControllerOfType: TabBarViewController.self, storyboardName: "TabBar")
        controller.viewModel = viewModel
        return controller
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    // MARK: Setup
    func setupViewController() {
        delegate = self
        if let controller = customizableViewControllers?.first as? UINavigationController {
            viewModel.coordinator.onViewDidLoad(navigationController: controller)
        }
    }
    
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
        switch selectedIndex {
        case TabBarFlowIndex.homeFlow.rawValue:
            viewModel.coordinator.onHomeFlowSelect(navigationController: controller)
        case TabBarFlowIndex.favoritesFlow.rawValue:
            viewModel.coordinator.onFavoritesFlowSelect(navigationController: controller)
        default:
            return
        }
    }
    
}
