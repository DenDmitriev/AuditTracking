//
//  Track.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 15.11.2023.
//

import Foundation

struct Track {
    let locationPoints: [LocationPoint]
    let distance: Double // km
    let maxSpeed: Double // km/h
    
    var startAt: Date? {
        locationPoints.first?.timestamp
    }
    
    var finishIn: Date? {
        locationPoints.last?.timestamp
    }
    
    static func buildTrack(json: [LocationPoint]) -> Self {
        var distanceM: Double = .zero // m
        var maxSpeedMS: Double = .zero // m/s
        let count = json.count
        let locationPoints = json.enumerated().map { (index, locationPoint) -> LocationPoint in
            guard count >= 2 else { return locationPoint }
            var locationPoint = locationPoint
            if index == .zero {
                locationPoint.speed = .zero
            } else {
                let indexBefore = json.index(before: index)
                let previous = json[indexBefore]
                locationPoint.calculateSpeedAndDistance(previous: previous)
                
                distanceM += locationPoint.distance ?? .zero
                if let speed = locationPoint.speed, speed > maxSpeedMS {
                    maxSpeedMS = speed
                }
            }
            
            if index == json.count - 1 {
                let indexBefore = json.index(before: index)
                let previous = json[indexBefore]
                locationPoint.course = previous.course
            } else {
                let indexAfter = json.index(after: index)
                let next = json[indexAfter]
                locationPoint.calculateCourse(next: next)
            }
            
            return locationPoint
        }
        let distance = distanceM / 1000
        let maxSpeed = (maxSpeedMS / 1000) / 60 * 60
        return Track(locationPoints: locationPoints, distance: distance, maxSpeed: maxSpeed)
    }
}

extension Track: Equatable {
    
}
