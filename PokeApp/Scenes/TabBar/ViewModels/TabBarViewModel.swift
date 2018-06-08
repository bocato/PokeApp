//
//  TabBarViewModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

protocol TabBarViewControllerActionsDelegate: class {
    var onTabSelect: ((_ selectedTab: TabBarIndex, _ navigationController: UINavigationController) -> ())? { get set }
}

enum TabBarIndex: Int {
    case home
    case favorites
}

protocol TabBarViewModelProtocol {
    
    // MARK: - Dependencies
    var actionsDelegate: TabBarViewControllerActionsDelegate? { get }
    
    // MARK: - Properties
    var selectedTab: Variable<TabBarIndex> { get set }
}

class TabBarViewModel: TabBarViewModelProtocol {
    
    // MARK: - Dependencies
    var actionsDelegate: TabBarViewControllerActionsDelegate?
    
    // MARK: - Variables
    var selectedTab = Variable<TabBarIndex>(.home)
    
    // MARK: Action Closures
    var onTabSelect: ((_ selectedTab: TabBarIndex) -> ())?
    
    init(actionsDelegate: TabBarViewControllerActionsDelegate) {
        self.actionsDelegate = actionsDelegate
    }
    
}
