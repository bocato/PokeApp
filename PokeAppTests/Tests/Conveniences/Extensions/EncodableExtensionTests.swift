//
//  EncodableExtensionTests.swift
//  PokeAppTests
//
//  Created by Eduardo Bocato on 02/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class EncodableExtensionTests: XCTestCase {

    // MARK: - Tests
    func testValidDictionaryValue() {
        // Given
        let encodableObject = EncodableObject(name: "SomeName", surname: "SomeSurname")
        let expectedDictionaryValue: [String: String] = ["name": "SomeName", "surname": "SomeSurname"]
        
        // When
        let dictionaryValue = encodableObject.dictionaryValue as? [String: String]
        
        // Then
        XCTAssertNotNil(dictionaryValue)
        XCTAssertEqual(dictionaryValue!, expectedDictionaryValue, "Invalid value.")
    }
    
}

private extension EncodableExtensionTests {
    
    struct EncodableObject: Encodable {
        let name: String
        let surname: String
    }
    
}
