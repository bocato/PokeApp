//
//  ErrorEnums.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

enum NetworkErrorCode: Int {
    case unknown = -111
    case unexpected = -222
    case serializationError = -333
    case invalidURL = -444
}

enum NetworkErrorMessage: String {
    case unknown = "An unknown error has occured. Try again later."
    case unexpected = "An unexpected error has occured. Check your internet connection and try again."
    case serializationError = "Object serialization error."
    case invalidURL = "Invalid URL."
}
