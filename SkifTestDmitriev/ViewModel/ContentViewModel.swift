//
//  ContentViewModel.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 14.11.2023.
//

import Foundation
import MapKit

class ContentViewModel: ObservableObject {
    
    @Published var track: Track?
    @Published var isProgress: Bool = false
    
    func fetchTrack() async throws {
        guard let url = URL(string: "https://dev5.skif.pro/coordinates.json") else { return }
        updateProgress(true)
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let json = try decoder.decode([LocationPoint].self, from: data)
        let track = Track.buildTrack(json: json)
        DispatchQueue.main.async {
            self.track = track
            self.updateProgress(false)
        }
    }
    
    private func updateProgress(_ isProgress: Bool) {
        DispatchQueue.main.async {
            self.isProgress = isProgress
        }
    }
}
