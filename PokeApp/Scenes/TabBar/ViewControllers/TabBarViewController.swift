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

class TabBarViewController: UITabBarController, RxControllable {
    
    // MARK: - Types
    typealias ViewModelType = TabBarViewModel
    
    // MARK: Dependencies
    internal var disposeBag: DisposeBag = DisposeBag()
    internal(set) var viewModel: TabBarViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    func setup() {
        delegate = self
        bindAll()
    }
    
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewModel.selectedTab.accept(TabBarViewModel.TabIndex(rawValue: tabBarController.selectedIndex)!)
    }
    
}

// MARK: - Binding
extension TabBarViewController {
    
    internal func bindAll() {
        viewModel.selectedTab
            .asObservable()
            .subscribe(onNext: { (selectedTab) in
                guard let controller = self.viewControllers?[selectedTab.rawValue] as? UINavigationController else { return }
                self.viewModel.actionsDelegate?.actOnSelectedTab(selectedTab, controller)
            })
            .disposed(by: disposeBag)
    }
    
}
