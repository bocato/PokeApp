//
//  MockRepositiory.swift
//  PokeAppUITests
//
//  Created by Eduardo Sanches Bocato on 05/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

class MockRepository<T: SessionMock> {
    
    private var permanentMocks: [T] = []
    private var temporaryMocks: [T] = []
    
    func removeAllMocks() {
        self.permanentMocks.removeAll()
        self.temporaryMocks.removeAll()
    }
    
    func add(permanent mock: T) {
        self.permanentMocks.append(mock)
    }
    
    func add(temporary mock: T) {
        self.temporaryMocks.append(mock)
    }
    
    func removeAllMocks(of request: URLRequest) {
        self.permanentMocks = self.permanentMocks.filter {
            return !$0.matches(request: request)
        }
        self.temporaryMocks = self.temporaryMocks.filter {
            return !$0.matches(request: request)
        }
    }
    
    /*
     Returns the next mock for the given request. If the next mock is temporary,
     it also removes it from the pool of temporary mocks.
     */
    func nextSessionMock(for request: URLRequest) -> SessionMock? {
        let mocksCopy = self.temporaryMocks
        
        // Temporary mocks have precedence over permanent mocks
        for (index, mock) in mocksCopy.enumerated() {
            if mock.matches(request: request) {
                self.temporaryMocks.remove(at: index)
                return mock
            }
        }
        
        for mock in self.permanentMocks {
            if mock.matches(request: request) {
                return mock
            }
        }
        
        return nil
    }
}


extension MockRepository where T: Equatable {
    
    func contains(temporary mock: T) -> Bool {
        return self.temporaryMocks.contains(mock)
    }
    
}
