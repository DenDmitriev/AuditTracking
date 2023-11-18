//
//  Track.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 15.11.2023.
//

import Foundation

class Track: Identifiable {
    let id: UUID
    let locationPoints: [LocationPoint]
    let distance: Double // km
    let maxSpeed: Double // km/h
    
    var startAt: Date? {
        locationPoints.first?.timestamp
    }
    
    var finishIn: Date? {
        locationPoints.last?.timestamp
    }
    
    init(locationPoints: [LocationPoint], distance: Double, maxSpeed: Double) {
        self.id = UUID()
        self.locationPoints = locationPoints
        self.distance = distance
        self.maxSpeed = maxSpeed
    }
    
    static func buildTrackOperation(
        json: [LocationPoint],
        handler: @escaping ((LoadingProgress) -> Void),
        completion: @escaping ((Track?) -> Void)
    ) {
        let operation = PrepareTrackOperation(json: json)
        operation.qualityOfService = .userInitiated
        operation.progress = { progress in
            handler(progress)
        }
        operation.completionBlock = {
            completion(operation.track)
        }
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        operationQueue.addOperation(operation)
    }
}

extension Track: Equatable {
    static func == (lhs: Track, rhs: Track) -> Bool {
        lhs.id == rhs.id
    }
}
