//
//  TrackStore.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 19.11.2023.
//

import Foundation

final class TrackStore: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var selectedTrack: Track.ID?
    
    var years: [Int] {
        let years = tracks.compactMap { track -> Int? in
            let year = track.day.year()
            return year
        }
        return Array(Set(years))
    }
    
    subscript(trackID: Track.ID?) -> Track {
        get {
            if let id = trackID {
                return tracks.first(where: { $0.id == id }) ?? .placeholder
            }
            return .placeholder
        }

        set(newValue) {
            if let id = trackID {
                tracks[tracks.firstIndex(where: { $0.id == id })!] = newValue
            }
        }
    }
    
    
    func months(year: Int) -> [Int] {
        var month = Set<Int>()
        tracks.forEach { track in
            guard
                track.year == year
            else { return }
            month.insert(track.month)
        }
        let result = month.sorted()
        
        return result
    }
    
    func tracks(month: Int, year: Int) -> [Track] {
        tracks.filter { track in
            track.year == year && track.month == month
        }
    }
}
