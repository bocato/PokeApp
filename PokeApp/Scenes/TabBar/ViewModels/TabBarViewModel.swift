//
//  TabBarViewModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 25/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

enum TabBarFlowIndex: Int {
    case homeFlow
    case favoritesFlow
}

class TabBarViewModel {
    
    let coordinator: TabBarCoordinator
    
    init(coordinator: TabBarCoordinator) {
        self.coordinator = coordinator
    }
    
}
