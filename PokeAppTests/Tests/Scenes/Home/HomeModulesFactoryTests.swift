//
//  HomeModulesFactoryTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 06/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class HomeModulesFactoryTests: XCTestCase  {
    
    // MARK: - Properties
    var sut: HomeCoordinatorModulesFactory!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = HomeCoordinatorModulesFactory()
    }
    
    // MARK: Tests
    func testBuildPokemonDetails() {
        // Given
        let router = Router()
        // When
        let (coordinator, controller) = sut.build(.pokemonDetails(1, router))
        let detailsCoordinator = coordinator as? DetailsCoordinator
        let detailsViewController = controller as? PokemonDetailsViewController
        // Then
        XCTAssertNotNil(detailsCoordinator)
        XCTAssertNotNil(detailsViewController)
    }
    
}
