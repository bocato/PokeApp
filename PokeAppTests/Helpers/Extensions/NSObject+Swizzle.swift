//
//  NSObject+Swizzle.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 05/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

enum Swizzle: Error {
    case failed(method: String)
}

extension NSObject {
    
    static func swizzle(replace from: String, with to: String) throws {
        let originalSelector = Selector(from)
        let swizzledSelector = Selector(to)
        
        guard
            let originalMethod = class_getInstanceMethod(self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else {
                throw Swizzle.failed(method: from)
        }
        
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            // class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            throw Swizzle.failed(method: from)
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
}
