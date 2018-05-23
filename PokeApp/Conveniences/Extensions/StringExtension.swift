//
//  StringExtension.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 20/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
}
