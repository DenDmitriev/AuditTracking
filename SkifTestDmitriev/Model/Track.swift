//
//  Track.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 15.11.2023.
//

import SwiftUI

class Track: Identifiable {
    let id: UUID
    var locationPoints: [LocationPoint]
    var distance: Double = .zero // km
    var maxSpeed: Double = .zero // km/h
    var date: Date?
    var day: Date?
    
    var pointCount: Int {
        locationPoints.count
    }
    
    var startAt: Date? {
        locationPoints.first?.timestamp
    }
    
    var finishIn: Date? {
        locationPoints.last?.timestamp
    }
    
    init(locationPoints: [LocationPoint], day: Date) {
        self.id = UUID()
        self.day = day
        self.locationPoints = locationPoints
    }
    
    func calculateProperties() {
        var distanceSumM: Double = .zero // m
        var maxSpeedMS: Double = .zero // m/s
        
        for (index, locationPoint) in locationPoints.enumerated() {
            if index == .zero {
                continue
            } else {
//                let previous = locationPoints[index - 1]
                let distance = locationPoint.distance ?? .zero // м
//                let speed = (locationPoint.speed ?? 0) / 1000 * 3600 // км/ч
//                let time = locationPoint.timestamp - previous.timestamp // сек
                
                distanceSumM += distance
                
                // Check speed for max
                if let speedMS = locationPoint.speed, maxSpeedMS < speedMS {
                    maxSpeedMS = speedMS
                }
            }
        }
        
        let distance = distanceSumM / 1000
        self.distance = distance
        
        let maxSpeed = (maxSpeedMS / 1000) * 60 * 60
        self.maxSpeed = maxSpeed
    }
}

extension Track: Equatable {
    static func == (lhs: Track, rhs: Track) -> Bool {
        lhs.id == rhs.id
    }
}

extension Track {
    static var placeholder: Track {
        guard
            let url = Bundle.main.url(forResource: "coordinateDebug", withExtension: "json")
        else { return Track(locationPoints: [], day: Date()) }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let json = try decoder.decode([LocationPoint].self, from: data)
            
            let count = json.count
            let locationPoints = json.enumerated().compactMap { index, locationPoint -> LocationPoint? in
                guard count >= 2 else { return locationPoint }
                var locationPoint = locationPoint
                if index == .zero {
                    locationPoint.speed = .zero
                } else {
                    let indexBefore = json.index(before: index)
                    let previous = json[indexBefore]
                    locationPoint.calculateSpeedAndDistance(previous: previous)
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
            
            return Track(locationPoints: locationPoints, day: Date().day()!)
        } catch let error {
            print(error.localizedDescription)
            return Track(locationPoints: [], day: Date())
        }
    }
}
