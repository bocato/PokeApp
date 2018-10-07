//
//  PokemonServiceStub.swift
//  PokeAppTests
//
//  Created by Eduardo Sanches Bocato on 07/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
@testable import PokeApp
import RxSwift

class PokemonServiceStub: PokemonServiceProtocol {
    
    enum MockData {
        case empty
        case bulbassaurData
        case pokemonList
        case error
    }
    
    var mockData: MockData
    
    init(mockData: MockData = .empty) {
        self.mockData = mockData
    }
    
    func getPokemonList() -> Observable<PokemonListResponse?> {
        return mockedPokemonList()
    }
    
    func getPokemonList(_ limit: Int) -> Observable<PokemonListResponse?> {
        return mockedPokemonList()
    }
    
    func getDetailsForPokemon(withId id: Int) -> Observable<Pokemon?> {
        switch mockData {
        case .error:
            return createErrorObservable(ofType: Pokemon.self)
        case .bulbassaurData:
            let data = MockDataHelper.getData(forResource: .bulbassaur)
            let serializedData = try? JSONDecoder().decode(Pokemon.self, from: data)
            return Observable.of(serializedData)
        default: return Observable.of(nil)
        }
    }
    
    // MARK: - Mock Helpers
    private func mockedPokemonList() -> Observable<PokemonListResponse?> {
        switch mockData {
        case .error:
            return createErrorObservable(ofType: PokemonListResponse.self)
        case .pokemonList:
            let data = MockDataHelper.getData(forResource: .bulbassaur)
            let serializedData = try? JSONDecoder().decode(PokemonListResponse.self, from: data)
            return Observable.of(serializedData)
        default: return Observable.of(nil)
        }
    }
    
    private func createErrorObservable<T: Codable>(ofType: T.Type) -> Observable<T?> {
        return Observable.create { observable in
            observable.onError(NetworkError())
            return Disposables.create()
        }
    }
    
}
