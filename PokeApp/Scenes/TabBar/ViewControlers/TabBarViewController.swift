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
    
    
    // MARK: - Dependencies
    let disposeBag = DisposeBag()
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
        setup()
    }
    
    // MARK: - Setup
    func setup() {
        delegate = self
        bindViewModel()
    }
    
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewModel.selectedTab.accept(TabBarViewModel.TabIndex(rawValue: tabBarController.selectedIndex)!)
    }
    
}

// MARK: - Binding
private extension TabBarViewController {
    
    func bindViewModel() {
        viewModel.selectedTab
            .asObservable()
            .subscribe(onNext: { (selectedTab) in
                guard let controller = self.viewControllers?[selectedTab.rawValue] as? UINavigationController else { return }
                self.viewModel.actionsDelegate?.actOnSelectedTab(selectedTab, controller)
            })
            .disposed(by: disposeBag)
        
    }
    
}
