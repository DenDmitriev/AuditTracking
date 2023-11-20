//
//  CalendarExtension.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 20.11.2023.
//

import Foundation

extension Calendar {
    static let months = ["январь", "февраль", "март", "апрель", "май", "июнь", "июль", "август", "сентябрь", "октябрь", "ноябрь", "декабрь"]
    static func month(number: Int) -> String {
        guard 1...12 ~= number else { return "Empty" }
        return Self.months[number - 1]
    }
}
