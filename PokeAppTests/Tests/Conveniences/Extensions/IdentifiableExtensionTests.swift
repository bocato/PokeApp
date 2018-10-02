//
//  IdentifiableExtensionTests.swift
//  PokeAppTests
//
//  Created by Eduardo Bocato on 02/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class IdentifiableExtensionTest: XCTestCase {
    
    func testUIViewIdentifier() {
        // Given
        let expectedIdentifier = "UIView"
        // When
        let identifier = UIView.identifier
        // Then
        XCTAssertEqual(identifier, expectedIdentifier, "Invalid UIView identifier")
    }
    
    func testUITableViewCellIdentifier() {
        // Given
        let expectedIdentifier = "UITableViewCell"
        // When
        let identifier = UITableViewCell.identifier
        // Then
        XCTAssertEqual(identifier, expectedIdentifier, "Invalid UITableViewCell identifier")
    }
    
    func testUICollectionViewCellIdentifier() {
        // Given
        let expectedIdentifier = "UICollectionViewCell"
        // When
        let identifier = UICollectionViewCell.identifier
        // Then
        XCTAssertEqual(identifier, expectedIdentifier, "Invalid UICollectionViewCell identifier")
    }
    
}
