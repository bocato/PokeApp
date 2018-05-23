//
//  JSONAny+Encodable.swift
//  WhiteLabel
//
//  Created by Eduardo Sanches Bocato on 14/11/17.
//  Copyright © 2017 Zup IT. All rights reserved.
//

import Foundation

extension JSONAny: Codable {
  
  public func encode(to encoder: Encoder) throws {
    
    var container = encoder.singleValueContainer()
    
    switch self {
    case let .array(array):
      try container.encode(array)
    case let .object(object):
      try container.encode(object)
    case let .string(string):
      try container.encode(string)
    case let .number(number):
      try container.encode(number)
    case let .bool(bool):
      try container.encode(bool)
    case .null:
      try container.encodeNil()
    }
  }
  
  public init(from decoder: Decoder) throws {
    
    let container = try decoder.singleValueContainer()
    
    if let object = try? container.decode([String: JSONAny].self) {
      self = .object(object)
    } else if let array = try? container.decode([JSONAny].self) {
      self = .array(array)
    } else if let string = try? container.decode(String.self) {
      self = .string(string)
    } else if let bool = try? container.decode(Bool.self) {
      self = .bool(bool)
    } else if let number = try? container.decode(Float.self) {
      self = .number(number)
    } else if container.decodeNil() {
      self = .null
    } else {
      throw DecodingError.dataCorrupted (
        .init(codingPath: decoder.codingPath, debugDescription: "Invalid JSON value.")
      )
    }
  }
  
}
