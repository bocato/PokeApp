//
//  PokemonDetailsViewModelTests.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 06/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp
import RxSwift
import RxCocoa

class PokemonDetailsViewModelTests: XCTestCase {

    // MARK: - Properties
    var detailsCoordinatorSpy: DetailsCoordinatorSpy!
    var favoritesManager: FavoritesManager!
    var imageDownloader: ImageDownloaderProtocol!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        setupTestEnvironment()
    }
    
    override func tearDown() {
        super.tearDown()
        favoritesManager.favorites.removeAll()
    }
    
    func setupTestEnvironment() {
        favoritesManager = SimpleFavoritesManager.shared
        detailsCoordinatorSpy = DetailsCoordinatorSpy(router: SimpleRouter())
        imageDownloader = ImageDownloaderStub()
    }

    // MARK: - Tests
    func testActOnFavoritesButtonTouch_AddingFavorite() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        
        let pokemonService = PokemonServiceStub()
        
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManager, imageDownloader: imageDownloader)
        let sut = PokemonDetailsViewModel(pokemonData: bulbassaur, dataSources: dataSources, actionsDelegate: detailsCoordinatorSpy)
        
        // When
        sut.actOnFavoritesButtonTouch()
        
        // Then
        let bulbassaurSearch = favoritesManager.favorites.filter( { $0.name == "bulbassaur" })
        XCTAssertNotNil(bulbassaurSearch)
    }
    
    func testActOnFavoritesButtonTouch_RemovingFavorite() {
        // Given
        let bulbassaur = try! JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur))
        favoritesManager.add(pokemon: bulbassaur)

        let pokemonService = PokemonService()
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManager, imageDownloader: imageDownloader)
        let sut = PokemonDetailsViewModel(pokemonData: bulbassaur, dataSources: dataSources, actionsDelegate: detailsCoordinatorSpy)

        // When
        sut.actOnFavoritesButtonTouch()
        
        // Then
        XCTAssertTrue(detailsCoordinatorSpy.didRemoveFavoriteWasCalled)
        let bulbassaurSearch = favoritesManager.favorites.filter( { $0.name == "bulbassaur" })
        XCTAssertTrue(bulbassaurSearch.isEmpty)
    }
    
    func testActOnFavoritesButtonTouchWithNilData() {
        // Given
        let pokemonService = PokemonServiceStub(mockType: .empty)
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManager, imageDownloader: imageDownloader)
        let sut = PokemonDetailsViewModel(pokemonId: 1, dataSources: dataSources, actionsDelegate: detailsCoordinatorSpy)
        
        // When
        sut.actOnFavoritesButtonTouch()
        
        // Then
        XCTAssertFalse(detailsCoordinatorSpy.didRemoveFavoriteWasCalled)
        XCTAssertFalse(detailsCoordinatorSpy.didAddFavoriteWasCalled)
    }
    
    func testLoadPokemonData_unexpectedError() {
        // Given
        let pokemonService = PokemonServiceStub(mockType: .empty)
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManager, imageDownloader: imageDownloader)
        let sut = PokemonDetailsViewModel(pokemonId: 1, dataSources: dataSources, actionsDelegate: detailsCoordinatorSpy)
        
        let viewStateCollector = RxCollector<CommonViewModelState>()
            .collect(from: sut.viewState.asObservable())
        let isLoadingPokemonDataCollector = RxCollector<Bool>()
            .collect(from: sut.isLoadingPokemonData.asObservable())
        
        // When
        sut.loadPokemonData()
        
        // Then
        guard let lastState = viewStateCollector.items.last, let isLoadingPokemonData = isLoadingPokemonDataCollector.items.last else {
            XCTFail("No states collected.")
            return
        }
        
        var isLastStateAnError = false
        switch lastState {
        case .error(_):
            isLastStateAnError = true
        default:
            isLastStateAnError = false
        }
        XCTAssertFalse(isLoadingPokemonData)
        XCTAssertTrue(isLastStateAnError)
    }
    
    func testLoadPokemonData_withBulbassaur() {
        // Given
        let pokemonService = PokemonServiceStub(mockType: .bulbassaurData)
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManager, imageDownloader: imageDownloader)
        let sut = PokemonDetailsViewModel(pokemonId: 1, dataSources: dataSources, actionsDelegate: detailsCoordinatorSpy)
        
        // When
        sut.loadPokemonData()
        
        // Then
        XCTAssertNotNil(sut.pokemonData)
    }
    
    func testLoadPokemonData_withServiceError() {
        // Given
        let mockError = NSError.buildMockError(code: 404, description: "LoadPokemonData error.")
        let pokemonService = PokemonServiceStub(mockType: .error(mockError))
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManager, imageDownloader: imageDownloader)
        let sut = PokemonDetailsViewModel(pokemonId: 1, dataSources: dataSources, actionsDelegate: detailsCoordinatorSpy)
        
        let viewStateCollector = RxCollector<CommonViewModelState>()
            .collect(from: sut.viewState.asObserver())
        
        // When
        sut.loadPokemonData()
        
        // Then
        XCTAssertNil(sut.pokemonData)
        var lastStateIsAnError = false
        if let lastState = viewStateCollector.items.last {
            switch lastState {
            case .error(_): lastStateIsAnError = true
            default: return
            }
            XCTAssertTrue(lastStateIsAnError)
        }
    }
    
    func testLoadPokemonImageReturningPlaceholder() {
        // Given
        let pokemonService = PokemonServiceStub(mockType: .bulbassaurData)
        let mockError = NSError.buildMockError(code: 404, description: "LoadPokemonData error.")
        let imageDownloader = ImageDownloaderStub(mockType: .error(mockError))
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManager, imageDownloader: imageDownloader)
        let sut = PokemonDetailsViewModel(pokemonId: 1, dataSources: dataSources, actionsDelegate: detailsCoordinatorSpy)

        let pokemonImageCollector = RxCollector<UIImage?>().collect(from: sut.pokemonImage.asObservable())

        // When
        sut.loadPokemonData()

        // Then
        let image = pokemonImageCollector.items.last!
        XCTAssertNotNil(image, "Invalid result.")
        let expectedImage = UIImage(named: "open_pokeball")
        XCTAssertEqual(image, expectedImage)
    }

    func testLoadPokemonImageReturningSomeImage() {
        // Given
        let pokemonService = PokemonServiceStub(mockType: .bulbassaurData)
        let image = UIImage()
        let imageDownloader = ImageDownloaderStub(mockType: .image(image))
        let dataSources = PokemonDetailsViewModel.DataSources(pokemonService: pokemonService, favoritesManager: favoritesManager, imageDownloader: imageDownloader)
        let sut = PokemonDetailsViewModel(pokemonId: 1, dataSources: dataSources, actionsDelegate: detailsCoordinatorSpy)
        
        let pokemonImageCollector = RxCollector<UIImage?>().collect(from: sut.pokemonImage.asObservable())
        
        // When
        sut.loadPokemonData()
        
        // Then
        let collectedImage = pokemonImageCollector.items.last!
        XCTAssertNotNil(collectedImage, "Invalid result.")
        XCTAssertEqual(image, collectedImage)
    }
    
}
