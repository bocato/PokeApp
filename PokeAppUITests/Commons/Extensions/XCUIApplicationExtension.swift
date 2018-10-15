//
//  XCUIApplicationExtension.swift
//  PokeAppUITests
//
//  Created by Eduardo Sanches Bocato on 21/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import XCTest

extension XCUIApplication {
    
    // MARK: Public Helpers
    func descendantElement(with identifier: String) -> XCUIElement {
        return descendants(matching: .any).matching(identifier: identifier).firstMatch
    }
    
}
