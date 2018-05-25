//
//  PokeAppTabBarViewModel.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 24/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import RxSwift

class PokeAppTabBarViewModel {
    
    // MARK: - Enums
    enum TabItem: Int {
        case favorites = 0
        case pokemons = 1
    }
    
    // MARK: - Properties
    var selectedIndex: TabItem = .favorites

    
    
}
