//
//  Environment.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

class Environment {
    
    // MARK: Enums
    enum EnvironmentType: String {
        case dev
    }
    
    // MARK: - Singleton
    static let shared = Environment()
    
    // MARK: - Properties
    var baseURL: String!
    var spritesURL: String!
    var runtimeEnvironment: EnvironmentType?
    
    // MARK: - Computed Properties
    var currentRuntimeEnvironment: EnvironmentType? {
        if let runtimeEnvironment = runtimeEnvironment {
            return runtimeEnvironment
        }
        return .dev
    }
    
    // MARK: - Lifecycle
    required init() {
        setup()
    }
    
    // MARK: - Configuration
    func setup() {
        guard let runtimeEnvironment = currentRuntimeEnvironment else { return }
        switch runtimeEnvironment {
        case .dev:
            self.baseURL = "https://pokeapi.co/api/v2/"
            self.spritesURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/"
        }
    }
    
}
