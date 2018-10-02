//
//  DateExtensionTests.swift
//  PokeAppTests
//
//  Created by Eduardo Bocato on 02/10/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import XCTest
@testable import PokeApp

class DateExtensionTest: XCTestCase {
    
    func testNewDateFromStringWithFormat() {
        guard let date = Date.new(from: "23/01/1990", format: "dd/MM/yyyy") else {
            XCTFail("Unable to create new date.")
            return
        }
        XCTAssertEqual(String(describing: type(of: date)), "Date", "new(from string: String, format: String) test failed.")
    }
    
    func testNewInstaceFromStringWithFormatAndTimeZone() {
        guard let date = Date.new(from: "31/01/1966", format: "dd/MM/yyyy", timeZone: TimeZone(abbreviation: "GMT") ) else {
            XCTFail("Unable to create new date with that timeZone.")
            return
        }
        XCTAssertEqual(String(describing: type(of: date)), "Date", "new(from string: String?, format: String!, timeZone: TimeZone!) test failed.")
    }
    
    func testStringWithFormat() {
        // Given
        let date = Date.new(from: "01/31/1966", format: "MM/dd/yyyy")
        let expectedDate = "31/01/1966"
        
        // When
        guard let newDate = date, let dateWithFormat = newDate.stringWithFormat("dd/MM/yyyy") else {
            XCTFail("Unable to format date with string.")
            return
        }
        
        // Then
        XCTAssertEqual(expectedDate, dateWithFormat, "Date string with formate failed.")
    }
    
}
