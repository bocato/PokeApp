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
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

//        if let controller = customizableViewControllers?.first as? UINavigationController {
//            onViewDidLoad?(controller)
//        }
    }
    
    // MARK: - Setup
    private func setup() {
        delegate = self
        selectedIndex = viewModel.selectedIndex.rawValue
        bindAll()
    }
    
}

// MARK: - UITabBarControllerDelegate
extension PokeAppTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
        viewModel.selectedIndex = selectedIndex
    }
    
}

// MARK: - Binding
private extension PokeAppTabBarController {
    
    func bindAll(){
        bindViewModel()
    }
    
    func bindViewModel() {
        
        
    }
    
    
}
