//
//  PrepareTrackOperation.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 18.11.2023.
//

import Foundation

class PrepareTrackOperation: Operation {
    
    let json: [LocationPoint]
    var track: Track?
    var progress: ((LoadingProgress) -> ())?
    
    init(json: [LocationPoint]) {
        self.json = json
        super.init()
    }
    
    override func main() {
        guard !isCancelled else { return }
        var distanceSumM: Double = .zero // m
        var maxSpeedMS: Double = .zero // m/s
        let count = json.count
        var progressPercent: Int = 0
        let locationPoints = json.enumerated().compactMap { (index, locationPoint) -> LocationPoint? in
            guard count >= 2 else { return locationPoint }
            var locationPoint = locationPoint
            if index == .zero {
                locationPoint.speed = .zero
            } else {
                let indexBefore = json.index(before: index)
                let previous = json[indexBefore]
                locationPoint.calculateSpeedAndDistance(previous: previous)
                let distance = locationPoint.distance ?? .zero // м
                let speed = (locationPoint.speed ?? 0) / 1000 * 3600 // км/ч
                let time = locationPoint.timestamp - previous.timestamp // сек
                
                // Check teleport point by speed
                if speed > 150, time <= 5 {
                    return nil
                }
                
                // Check teleport point by distance
                if distance > 3000, time <= 60 {
                    return nil
                }
                
                // Delete teleport by location between previous and next
                if index < count - 1 {
                    let indexAfter = json.index(after: index)
                    let next = json[indexAfter]
                    let distanceBetweenPreviousAndCurrent = (previous.distance ?? .zero) + distance
                    let distanceBetweenPreviousAndNext = next.clLocation.distance(from: previous.clLocation)
                    
                    if (distanceBetweenPreviousAndNext * 2) < distanceBetweenPreviousAndCurrent {
                        return nil
                    }
                }
                
//                print("\(Int(speed));" + "\(Int(duration));" + "\(Int(distance));;")
                
                distanceSumM += distance
                
                // Check speed for max
                if let speedMS = locationPoint.speed,
                   speedMS > maxSpeedMS,
                   speed < 200, // less 200 km/h
                   100...10000 ~= distance, // more 100 m less 10km
                   time > 3
                {
                    maxSpeedMS = speedMS
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
            
            let newProgressPercent = Int(Double(index) / Double(count) * 100)
            if newProgressPercent > progressPercent {
                let loadingProgress = LoadingProgress(value: newProgressPercent, total: 100)
                self.progress?(loadingProgress)
                progressPercent = newProgressPercent
            }
            
            return locationPoint
        }
        
        let distance = distanceSumM / 1000
        let maxSpeed = (maxSpeedMS / 1000) * 60 * 60
        
        let track = Track(locationPoints: locationPoints, distance: distance, maxSpeed: maxSpeed)
        
        self.track = track
    }
}
