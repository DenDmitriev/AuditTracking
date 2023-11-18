//
//  TrackManager.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 17.11.2023.
//

import SwiftUI

final class TrackManager: ObservableObject {
    @Published var track: Track?
    @Published var isProgress: Bool = false
    @Published var progress: Int = 0
    @Published var total: Int = 1
    
    lazy var speed: Binding<Double?> = .init(
        get: { [self] in
            guard let speed = track?.locationPoints[self.progress].speed else { return 0 }
            let convertedSpeed = ((speed / 1000) * 60 * 60).rounded()
            return convertedSpeed
        },
        set: { _ in }
    )
    
    func fetchTrack() async throws {
        guard let url = URL(string: "https://dev5.skif.pro/coordinates.json") else { return }
        updateProgress(true)
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let json = try decoder.decode([LocationPoint].self, from: data)
        let track = Track.buildTrack(json: json)
        DispatchQueue.main.async {
            self.track = track
            self.total = track.locationPoints.count - 1
            self.updateProgress(false)
        }
    }
    
    private func updateProgress(_ isProgress: Bool) {
        DispatchQueue.main.async {
            self.isProgress = isProgress
        }
    }
}
