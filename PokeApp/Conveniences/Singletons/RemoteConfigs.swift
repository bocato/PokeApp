//
//  RemoteConfig.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 26/07/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import Firebase

class RemoteConfigs {
    
    // MARK: Constants
    private struct Constants {
        static let defaultExpirationDuration = 1
        static let areRefactorTestsEnabledConfigKey = "are_refactor_tests_enabled"
    }
    
    // MARK: - Properties
    private var remoteConfig: RemoteConfig!
    
    // MARK: - Singleton
    static let shared = RemoteConfigs()
    
    // MARK: - Computed Properties
    var areRefactorTestsEnabled: Bool {
        return remoteConfig[Constants.areRefactorTestsEnabledConfigKey].boolValue
    }
    
    // MARK: - Initialization
    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    
    func fetchConfigs() {
    
        var expirationDuration = Constants.defaultExpirationDuration
    
        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
    
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                debugPrint("Configs fetched!")
                    self.remoteConfig.activateFetched()
                } else {
                    debugPrint("Configs not fetched")
                    debugPrint("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
        
    
    }
    
}
