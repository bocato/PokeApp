//
//  JSONAny+Initialization.swift
//  WhiteLabel
//
//  Created by Eduardo Sanches Bocato on 14/11/17.
//  Copyright © 2017 Zup IT. All rights reserved.
//

import Foundation

extension JSONAny {
  
  public init(_ value: Any) throws {
    switch value {
    case let num as Float:
      self = .number(num)
    case let num as Int:
      self = .number(Float(num))
    case let str as String:
      self = .string(str)
    case let bool as Bool:
      self = .bool(bool)
    case let array as [Any]:
      self = .array(try array.map(JSONAny.init))
    case let dict as [String:Any]:
      self = .object(try dict.mapValues(JSONAny.init))
    default:
      throw JSONError.decodingError
    }
  }
  
  public init<T: Codable>(codable: T) throws {
    let encoded = try JSONEncoder().encode(codable)
    self = try JSONDecoder().decode(JSONAny.self, from: encoded)
  }
  
}

extension JSONAny: ExpressibleByBooleanLiteral {
  
  public init(booleanLiteral value: Bool) {
    self = .bool(value)
  }
  
}

extension JSONAny: ExpressibleByNilLiteral {
  
  public init(nilLiteral: ()) {
    self = .null
  }
  
}

extension JSONAny: ExpressibleByArrayLiteral {
  
  public init(arrayLiteral elements: JSONAny...) {
    self = .array(elements)
  }
  
}

extension JSONAny: ExpressibleByDictionaryLiteral {
  
  public init(dictionaryLiteral elements: (String, JSONAny)...) {
    var object: [String:JSONAny] = [:]
    for (k, v) in elements {
      object[k] = v
    }
    self = .object(object)
  }
  
}

extension JSONAny: ExpressibleByFloatLiteral {
  
  public init(floatLiteral value: Float) {
    self = .number(value)
  }
  
}

extension JSONAny: ExpressibleByIntegerLiteral {
  
  public init(integerLiteral value: Int) {
    self = .number(Float(value))
  }
  
}

extension JSONAny: ExpressibleByStringLiteral {
  
  public init(stringLiteral value: String) {
    self = .string(value)
  }
  
}
