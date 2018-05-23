//
//  DateExtension.swift
//  PokeApp
//
//  Created by Eduardo Sanches Bocato on 14/05/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation

extension Date {
    
    func stringWithFormat(_ format: String) -> String? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    static func new(from string: String, format: String) -> Date? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
    
    static func new(from string: String?, format: String!, timeZone: TimeZone!) -> Date? {
        guard let string = string else { return nil }
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: string)
    }
    
}
