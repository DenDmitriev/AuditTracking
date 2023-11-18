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
        var distanceM: Double = .zero // m
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
                let distance = locationPoint.distance ?? .zero
                
                // Delete teleport point
                if distance > 1000 {
                    return nil
                }
                
                distanceM += distance
                
                // Check speed for max
                if let speed = locationPoint.speed,
                   speed > maxSpeedMS,
                   speed < 50, // less 50 m/s
                   100...10000 ~= distance // more 100 m less 10km
                {
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
            
            let newProgressPercent = Int(Double(index) / Double(count) * 100)
            if newProgressPercent > progressPercent {
                let loadingProgress = LoadingProgress(value: newProgressPercent, total: 100)
                self.progress?(loadingProgress)
                progressPercent = newProgressPercent
            }
            
            return locationPoint
        }
        
        let distance = distanceM / 1000
        let maxSpeed = (maxSpeedMS / 1000) * 60 * 60
        
        let track = Track(locationPoints: locationPoints, distance: distance, maxSpeed: maxSpeed)
        
        self.track = track
    }
}
