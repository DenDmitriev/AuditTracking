//
//  IntExtension.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 20.11.2023.
//

import Foundation

extension Int {
    func tracks() -> String {
        var dayString: String = ""
        if "1".contains("\(self % 10)") {dayString = "трек"}
        if "234".contains("\(self % 10)") {dayString = "трека" }
        if "567890".contains("\(self % 10)") {dayString = "треков"}
//        if 11...14 ~= self % 100 {dayString = "треков"}
        
        return "\(self) " + dayString
    }
}
