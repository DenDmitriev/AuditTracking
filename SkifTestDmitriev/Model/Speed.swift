//
//  Speed.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 14.11.2023.
//

import SwiftUI
import UIKit.UIColor

enum Speed: Int, CaseIterable {
    case city
    case road
    case highway
    
    var legend: String {
        switch self {
        case .city:
            return "от 0 до 70 км/ч"
        case .road:
            return "от 70 до 90 км/ч"
        case .highway:
            return "более 90 км/ч"
        }
    }
    
    var color: Color {
        switch self {
        case .city:
            return Color("CitySpeed")
        case .road:
            return Color("RoadSpeed")
        case .highway:
            return Color("HighwaySpeed")
        }
    }
    
    var uiColor: UIColor {
        switch self {
        case .city:
            return UIColor(named: "CitySpeed") ?? .gray
        case .road:
            return UIColor(named: "RoadSpeed") ?? .gray
        case .highway:
            return UIColor(named: "HighwaySpeed") ?? .gray
        }
    }
    
    init(speed: Int) {
        switch speed {
        case ...70:
            self = .city
        case 71...90:
            self = .road
        case 91...:
            self = .highway
        default:
            self = .city
        }
    }
}
