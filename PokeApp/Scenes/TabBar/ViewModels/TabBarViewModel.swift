//
//  TabBarViewModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol TabBarViewControllerActionsDelegate: class {
    func actOnSelectedTab(_ selectedTab: TabBarViewModel.TabIndex, _ navigationController: UINavigationController)
}

class TabBarViewModel {
    
    enum TabIndex: Int {
        case home
        case favorites
    }
    
    // MARK: - Dependencies
    private(set) weak var actionsDelegate: TabBarViewControllerActionsDelegate?
    
    // MARK: - Variables
    private(set) var selectedTab = BehaviorRelay<TabIndex>(value: .home)
    
    init(actionsDelegate: TabBarViewControllerActionsDelegate) {
        self.actionsDelegate = actionsDelegate
    }
    
}
