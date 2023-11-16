//
//  LocationPoint.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 14.11.2023.
//

import Foundation
import MapKit

struct LocationPoint: Decodable, Hashable {
    let timestamp: Date
    let latitude: Double
    let longitude: Double
    var course: Double? // от севера по компасу
    var speed: Double? // m/s
    var distance: Double? // m
    
    var coordinate: CLLocationCoordinate2D {
        return .init(latitude: latitude, longitude: longitude)
    }
    
    var clLocation: CLLocation {
        CLLocation(
            coordinate: coordinate,
            altitude: 0,
            horizontalAccuracy: 1,
            verticalAccuracy: 1,
            course: course ?? .zero,
            speed: speed ?? .zero,
            timestamp: timestamp
        )
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        let formatter = ISO8601DateFormatter()
        let timestampString = try container.decode(String.self)
        self.timestamp = formatter.date(from: timestampString + "Z")!
        
        self.latitude = try container.decode(Double.self)
        self.longitude = try container.decode(Double.self)
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(timestamp)
    }
    
    mutating func calculateSpeedAndDistance(previous: Self) {
        if speed == nil {
            let time = self.timestamp - previous.timestamp
            let clLocation = CLLocation(latitude: latitude, longitude: longitude)
            let previousClLocation = CLLocation(latitude: previous.latitude, longitude: previous.longitude)
            let distance = clLocation.distance(from: previousClLocation)
            self.distance = distance
            
            self.speed = distance / time
        }
    }
    
    mutating func calculateCourse(next: Self) {
        if course == nil {
            let lat1 = degreesToRadians(degrees: latitude)
            let lon1 = degreesToRadians(degrees: longitude)

            let lat2 = degreesToRadians(degrees: next.latitude)
            let lon2 = degreesToRadians(degrees: next.longitude)

            let dLon = lon2 - lon1

            let y = sin(dLon) * cos(lat2)
            let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
            let radiansBearing = atan2(y, x)

            let course = radiansToDegrees(radians: radiansBearing)
            
            self.course = course
        }
    }
    
    private func degreesToRadians(degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    private func radiansToDegrees(radians: Double) -> Double {
        return radians * 180.0 / .pi
    }
}
