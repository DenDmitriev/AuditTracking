//
//  Speed.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 14.11.2023.
//

import SwiftUI
import UIKit.UIColor
import GoogleMaps

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
    
    var styleSolid: GMSStrokeStyle {
        switch self {
        case .city:
            return Styles.city
        case .road:
            return Styles.road
        case .highway:
            return Styles.highway
        }
    }
    
    static func styleGradient(from: Speed, to: Speed) -> GMSStrokeStyle {
        switch from {
        case .city:
            switch to {
            case .city:
                return Styles.city
            case .road:
                return Styles.cityToRoad
            case .highway:
                return Styles.cityToHighway
            }
        case .road:
            switch to {
            case .city:
                return Styles.RoadToCity
            case .road:
                return Styles.road
            case .highway:
                return Styles.RoadToHighway
            }
        case .highway:
            switch to {
            case .city:
                return Styles.HighwayToCity
            case .road:
                return Styles.HighwayToRoad
            case .highway:
                return Styles.highway
            }
        }
    }
    
    struct Styles {
        static let city: GMSStrokeStyle = .solidColor(Speed.city.uiColor)
        static let road: GMSStrokeStyle = .solidColor(Speed.road.uiColor)
        static let highway: GMSStrokeStyle = .solidColor(Speed.highway.uiColor)
        
        static let cityToRoad: GMSStrokeStyle = .gradient(from: Speed.city.uiColor, to: Speed.road.uiColor)
        static let cityToHighway: GMSStrokeStyle = .gradient(from: Speed.city.uiColor, to: Speed.highway.uiColor)
        static let RoadToHighway: GMSStrokeStyle = .gradient(from: Speed.road.uiColor, to: Speed.highway.uiColor)
        static let RoadToCity: GMSStrokeStyle = .gradient(from: Speed.road.uiColor, to: Speed.city.uiColor)
        static let HighwayToRoad: GMSStrokeStyle = .gradient(from: Speed.highway.uiColor, to: Speed.road.uiColor)
        static let HighwayToCity: GMSStrokeStyle = .gradient(from: Speed.highway.uiColor, to: Speed.city.uiColor)
    }
    
    
    init(speed: Int) {
        switch speed {
        case ...20: // 70
            self = .city
        case 21...25: // 71...90
            self = .road
        case 26...: // 91...
            self = .highway
        default:
            self = .city
        }
    }
}
