//
//  TrackStore.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 19.11.2023.
//

import Foundation

final class TrackStore: ObservableObject {
    @Published var name: String = "Бензовоз"
    
    @Published var tracks: [Track] = []
    @Published var selectedTrack: Track.ID?
    
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
}
