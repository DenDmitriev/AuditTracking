//
//  AppFormatters.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 23.11.2023.
//

import Foundation

struct AppFormatters {
    static var dateFormatterDM: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        dateFormatter.locale = Locale(identifier: "Ru-ru")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }()
}
