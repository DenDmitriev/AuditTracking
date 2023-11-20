//
//  PrepareTrackOperation.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 18.11.2023.
//

import Foundation

class PrepareTrackOperation: Operation {
    
    let json: [LocationPoint]
    var tracks: [Track] = []
    var progress: ((LoadingProgress) -> ())?
    
    init(json: [LocationPoint]) {
        self.json = json
        super.init()
    }
    
    override func main() {
        guard !isCancelled else { return }
        
        let count = json.count
        var progressPercent: Int = 0
        
        // Clearing and prepare location
        for (index, locationPoint) in json.enumerated() {
            guard count >= 2 else { continue }
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
                    continue
                }
                
                // Check teleport point by distance
                if distance > 3000, time <= 60 {
                    continue
                }
                
                // Delete teleport by location between previous and next
                if index < count - 1 {
                    let indexAfter = json.index(after: index)
                    let next = json[indexAfter]
                    let distanceBetweenPreviousAndCurrent = (previous.distance ?? .zero) + distance
                    let distanceBetweenPreviousAndNext = next.clLocation.distance(from: previous.clLocation)
                    
                    if (distanceBetweenPreviousAndNext * 2) < distanceBetweenPreviousAndCurrent {
                        continue
                    }
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
            
            // Add day if no exist for separate by day
            if let day = locationPoint.timestamp.day() {
                if let trackIndex = tracks.firstIndex(where: { $0.day == day }) {
                    tracks[trackIndex].locationPoints.append(locationPoint)
                } else {
                    tracks.append(Track(name: "Бензовоз", locationPoints: [locationPoint], day: day))
                }
            }
        }
        
        tracks.forEach { track in
            track.calculateProperties()
        }
    }
}
