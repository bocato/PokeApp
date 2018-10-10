//
//  FavoritesViewModelTests.swift
//  PokeAppTests
//
//  Created by Eduardo Bocato on 04/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class FavoritesViewModelTests: XCTestCase {

    // MARK: - Properties
    var sut: FavoritesViewModelSpy!
    var favoritesCoordinatorSpy: FavoritesCoordinatorSpy!
    var favoritesManager: FavoritesManager!
    var imageDownloader: ImageDownloaderProtocol!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        favoritesManager = SimpleFavoritesManager.shared
        favoritesCoordinatorSpy = FavoritesCoordinatorSpy(router: SimpleRouter(), modulesFactory: FavoritesCoordinatorModulesFactory(), favoritesManager: favoritesManager)
        imageDownloader = KingfisherImageDownloader() // TODO: Change this to the mock version
        sut = FavoritesViewModelSpy(actionsDelegate: favoritesCoordinatorSpy, favoritesManager: favoritesManager, imageDownloader: imageDownloader)
    }
    
    override func tearDown() {
        super.tearDown()
        favoritesManager.favorites.removeAll()
    }
    
    // MARK: - Tests
    func testInit() {
        XCTAssertNotNil(sut, "initalization failed")
        XCTAssertNotNil(sut.actionsDelegate, "ActionsDelegate was not set")
        XCTAssertNotNil(sut.favoritesManager)
    }
    
    func testLoadFavoritesEmpty() {
        // Given
        let expectedStates: [CommonViewModelState] = [.empty]
        
        let viewStateCollector = RxCollector<CommonViewModelState>()
            .collect(from: sut.viewState.asObservable())
        let favoriteCollectionViewCellModelsCollector = RxCollector<[FavoriteCollectionViewCellModel]>()
            .collect(from: sut.favoritesCellModels.asObservable())
        
        // When
        sut.loadFavorites()

        // Then
        XCTAssertEqual(viewStateCollector.items, expectedStates, "State stream is invalid")
        XCTAssertNotNil(favoriteCollectionViewCellModelsCollector.items.first)
        XCTAssertTrue(favoriteCollectionViewCellModelsCollector.items.first!.isEmpty, "Items is not empty")
    }
    
    func testLoadFavoritesLoadedState() {
        // Given
        let expectedStates: [CommonViewModelState] = [.loaded]
        let pikachu = Pokemon(id: 90909123, name: "pikachu", baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        
        let viewStateCollector = RxCollector<CommonViewModelState>()
            .collect(from: sut.viewState.asObservable())
        let favoriteCollectionViewCellModelsCollector = RxCollector<[FavoriteCollectionViewCellModel]>()
            .collect(from: sut.favoritesCellModels.asObservable())
        
        // When
        favoritesManager.add(pokemon: pikachu)
        sut.loadFavorites()
        
        // Then
        XCTAssertEqual(viewStateCollector.items, expectedStates, "State stream is invalid")
        XCTAssertNotNil(favoriteCollectionViewCellModelsCollector.items.first)
        XCTAssertTrue(favoriteCollectionViewCellModelsCollector.items.first!.count == 1, "Items is not empty")
    }
    
    func testShowItemDetailsForSelectedFavoriteCellModel_success() {
        // Given
        guard let bulbassaur = try? JSONDecoder().decode(Pokemon.self, from: MockDataHelper.getData(forResource: .bulbassaur)) else {
            XCTFail("Could not prepare test case.")
            return
        }
        let favoriteCollectionViewCellModel = FavoriteCollectionViewCellModel(data: bulbassaur, imageDownloader: imageDownloader)
        
        // When
        sut.showItemDetailsForSelectedFavoriteCellModel(favoriteCellModel: favoriteCollectionViewCellModel)
        
        // Then
        XCTAssertTrue(favoritesCoordinatorSpy.showItemDetailsForPokemonWithIdWasCalled)
        XCTAssertNotNil(favoritesCoordinatorSpy.idForLastPokemonDetailsRequest)
        XCTAssertEqual(favoritesCoordinatorSpy.idForLastPokemonDetailsRequest!, 1, "Invalid bulbassaur.")
    }
    
    func testShowItemDetailsForSelectedFavoriteCellModel_failure() {
        // Given
        let invalidPokemon = Pokemon(id: nil, name: "Missigno", baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        let favoriteCollectionViewCellModel = FavoriteCollectionViewCellModel(data: invalidPokemon, imageDownloader: imageDownloader)
        
        // When
        sut.showItemDetailsForSelectedFavoriteCellModel(favoriteCellModel: favoriteCollectionViewCellModel)
        
        // Then
        XCTAssertFalse(favoritesCoordinatorSpy.showItemDetailsForPokemonWithIdWasCalled)
        XCTAssertNil(favoritesCoordinatorSpy.idForLastPokemonDetailsRequest)
    }
    
    func testReceiveOutputFromHomeCoordinator() {
        // Given
        let router = SimpleRouter()
        let tabBarCoordinator = TabBarCoordinator(router: router, modulesFactory: TabBarCoordinatorModulesFactory())
        tabBarCoordinator.delegate = sut
        
        let homeCoordinator = HomeCoordinator(router: router, favoritesManager: favoritesManager, modulesFactory: HomeCoordinatorModulesFactory())
        tabBarCoordinator.addChildCoordinator(homeCoordinator)
        
        let detailsCoordinator = DetailsCoordinator(router: router)
        homeCoordinator.addChildCoordinator(detailsCoordinator)
        
        let outputToSend: DetailsCoordinator.Output = .didAddPokemon
        
        // When
        detailsCoordinator.sendOutputToParent(outputToSend)
        
        // Then
        let coordinatorWhoSentTheLastOutput = sut.coordinatorWhoSentTheLastOutput as? HomeCoordinator
        XCTAssertNotNil(coordinatorWhoSentTheLastOutput)
        
        let lastReceivedParentOutput = sut.lastReceivedOutput as? HomeCoordinator.Output
        XCTAssertNotNil(lastReceivedParentOutput)
        XCTAssertEqual(lastReceivedParentOutput!, .shouldReloadFavorites, "Invalid output.")
    }
    
    
    func testReceiveOutputFromFavoritesCoordinator() {
        // Given
        let router = SimpleRouter()
        let tabBarCoordinator = TabBarCoordinator(router: router, modulesFactory: TabBarCoordinatorModulesFactory())
        tabBarCoordinator.delegate = sut
        
        let favoritesCoordinator = FavoritesCoordinator(router: router, modulesFactory: FavoritesCoordinatorModulesFactory(), favoritesManager: favoritesManager)
        tabBarCoordinator.addChildCoordinator(favoritesCoordinator)
        
        let detailsCoordinator = DetailsCoordinator(router: router)
        favoritesCoordinator.addChildCoordinator(detailsCoordinator)
        
        let outputToSend: DetailsCoordinator.Output = .didAddPokemon
        
        // When
        detailsCoordinator.sendOutputToParent(outputToSend)
        
        // Then
        let coordinatorWhoSentTheLastOutput = sut.coordinatorWhoSentTheLastOutput as? FavoritesCoordinator
        XCTAssertNotNil(coordinatorWhoSentTheLastOutput)
        
        let lastReceivedParentOutput = sut.lastReceivedOutput as? FavoritesCoordinator.Output
        XCTAssertNotNil(lastReceivedParentOutput)
        XCTAssertEqual(lastReceivedParentOutput!, .shouldReloadFavorites, "Invalid output.")
    }
    
    func testIfFavoritesIsSorted() {
        // Given
        let pokemon1 = Pokemon(id: 1, name: "Pikachu", baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        let pokemon2 = Pokemon(id: 2, name: "Pikachu", baseExperience: nil, height: nil, isDefault: nil, order: nil, weight: nil, abilities: nil, forms: nil, gameIndices: nil, moves: nil, species: nil, stats: nil, types: nil)
        
        
        let favoriteCollectionViewCellModelsCollector = RxCollector<[FavoriteCollectionViewCellModel]>()
            .collect(from: sut.favoritesCellModels.asObservable())
        
        // When
        favoritesManager.add(pokemon: pokemon2)
        favoritesManager.add(pokemon: pokemon1)
        sut.loadFavorites()
        
        // Then
        let favoritesManagerIds = favoritesManager.favorites.map { (pokemon) -> Int in
            return pokemon.id!
        }
        XCTAssertNotNil(favoriteCollectionViewCellModelsCollector.items.first)
        let cellModelsIds = favoriteCollectionViewCellModelsCollector.items.first!.map { (cellModel) -> Int in
            return cellModel.pokemonData.id!
        }
        XCTAssertNotEqual(favoritesManagerIds, cellModelsIds)
    }
    
    
}

// MARK: - Spies
class FavoritesViewModelSpy: FavoritesViewModel {
    
    // MARK: - Control Variables
    var lastReceivedOutput: CoordinatorOutput?
    var coordinatorWhoSentTheLastOutput: Coordinator?
    
    // MARK: - CoordinatorDelegate
    override func receiveOutput(_ output: CoordinatorOutput, fromCoordinator coordinator: Coordinator) {
        lastReceivedOutput = output
        coordinatorWhoSentTheLastOutput = coordinator
        super.receiveOutput(output, fromCoordinator: coordinator)
    }
    
}
