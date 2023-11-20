//
//  Date.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 15.11.2023.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func isSomeDay(with date: Date) -> Bool {
        guard
            let source = self.day(),
            let target = date.day()
        else { return false }
        
        return source == target
    }
    
    func day() -> Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let date = calendar.date(from: dateComponents)
        
        return date
    }
    
    func month() -> Int? {
        let calendar = Calendar.current
        let month = calendar.dateComponents([.month], from: self).month
        return month
    }
    
    func year() -> Int? {
        let calendar = Calendar.current
        let year = calendar.dateComponents([.year], from: self).year
        return year
    }
}
