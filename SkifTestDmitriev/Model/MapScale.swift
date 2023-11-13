//
//  MapScale.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import Foundation

enum MapScale: Int {
    case one = 1
    case four = 4
    case eight = 8
    
    func next() -> Self {
        switch self {
        case .one:
            return .four
        case .four:
            return .eight
        case .eight:
            return .one
        }
    }
}
