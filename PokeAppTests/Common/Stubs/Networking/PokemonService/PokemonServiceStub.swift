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
    
    enum MockType {
        case empty
        case bulbassaurData
        case pokemonList
        case error(NSError?)
    }
    
    var mockType: MockType
    
    init(mockType: MockType = .empty) {
        self.mockType = mockType
    }
    
    func getPokemonList() -> Observable<PokemonListResponse?> {
        return mockedPokemonList()
    }
    
    func getPokemonList(_ limit: Int) -> Observable<PokemonListResponse?> {
        return mockedPokemonList()
    }
    
    func getDetailsForPokemon(withId id: Int) -> Observable<Pokemon?> {
        switch mockType {
        case .error(let nsError):
            return createErrorObservable(ofType: Pokemon.self, withError: nsError)
        case .bulbassaurData:
            let data = MockDataHelper.getData(forResource: .bulbassaur)
            let serializedData = try? JSONDecoder().decode(Pokemon.self, from: data)
            return Observable.of(serializedData)
        default: return Observable.of(nil)
        }
    }
    
    // MARK: - Mock Helpers
    private func mockedPokemonList() -> Observable<PokemonListResponse?> {
        switch mockType {
        case .error(let nsError):
            return createErrorObservable(ofType: PokemonListResponse.self, withError: nsError)
        case .pokemonList:
            let data = MockDataHelper.getData(forResource: .pokemonList)
            let serializedData = try? JSONDecoder().decode(PokemonListResponse.self, from: data)
            return Observable.of(serializedData)
        default: return Observable.of(nil)
        }
    }
    
    private func createErrorObservable<T: Codable>(ofType: T.Type, withError error: NSError?) -> Observable<T?> {
        return Observable.create { observable in
            var mockedNetworkError = NetworkError(rawError: NSError.buildMockError())
            if let error = error {
                mockedNetworkError = NetworkError(rawError: error)
            }
            observable.onError(mockedNetworkError)
            return Disposables.create()
        }
    }
    
}
