//
//  CommonViewModelStates.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 07/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

enum CommonViewModelState {
    case loading(Bool)
    case error(SerializedNetworkError?)
    case empty
    case loaded
}

extension CommonViewModelState: Equatable {
    
    static func == (lhs: CommonViewModelState, rhs: CommonViewModelState) -> Bool {
        switch (lhs, rhs) {
        case let (.loading(l), .loading(r)): return l == r
        case (.empty, .empty): return true
        case let (.error(l), .error(r)): return l.debugDescription == r.debugDescription // check this, conform objects to equatable
        case (.loaded, .loaded): return true
        default: return false
        }
    }
    
}
