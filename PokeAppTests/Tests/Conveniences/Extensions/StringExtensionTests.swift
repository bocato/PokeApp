//
//  StringExtensionTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 06/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class StringExtensionTests: XCTestCase {

    // MARK: -
    func testCapitalizingFirstLetter() {
        // Given
        let string = "string"
        // When
        let capitalized = string.capitalizingFirstLetter()
        // Then
        XCTAssertNotNil(capitalized.first)
        XCTAssertEqual(capitalized.first!, "S", "First letter was not capitalized.")
    }

}
