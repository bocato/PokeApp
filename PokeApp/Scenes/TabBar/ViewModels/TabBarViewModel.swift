//
//  TabBarViewModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift

enum TabBarIndex: Int {
    case homeFlow
    case favoritesFlow
}

class TabBarViewModel {
    
    // MARK: - Dependencies
    let coordinator: TabBarCoordinator
    
    // MARK: - Variables
    var selectedTab = Variable<TabBarIndex>(.homeFlow)
    
    init(coordinator: TabBarCoordinator) {
        self.coordinator = coordinator
    }
    
}
