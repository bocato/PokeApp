//
//  XCUIElementExtension.swift
//  PokeAppUITests
//
//  Created by Eduardo Sanches Bocato on 22/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import XCTest
import UIKit

enum SwipeOrientation {
    case up
    case down
    case left
    case right
}

extension XCUIElement {
    
    func tapAndType(_ text: String) {
        tap()
        typeText(text)
    }
    
    func pageControlInfo() -> (currentPage: Int, numberOfPages: Int)? {
        
        guard let stringValue = self.value as? String else {
            return nil
        }
        
        let split = stringValue.split(separator: " ")
        var intValues = [Int]()
        split.forEach { (substring) in
            if let intValue = Int(substring) {
                intValues.append(intValue)
            }
        }
        
        guard  let currentPage = intValues.first, let numberOfPages = intValues.last, intValues.count == 2 else {
            return nil
        }
        
        return (currentPage, numberOfPages)
    }
    
    func isVisible(in app: XCUIApplication) -> Bool {
        guard exists && isHittable && !frame.isEmpty else {
            return false
        }
        return app.windows.element(boundBy: 0).frame.contains(frame)
    }
    
    func scroll(to element: XCUIElement, in app: XCUIApplication, orientation: SwipeOrientation = .up) {
        while !element.isVisible(in: app) {
            swipe(orientation)
        }
    }
    
    
    
    func swipe(_ orientation: SwipeOrientation) {
        switch orientation {
        case .up:
            swipeUp()
        case .down:
            swipeDown()
        case .left:
            swipeLeft()
        case .right:
            swipeRight()
        }
    }
    
}
