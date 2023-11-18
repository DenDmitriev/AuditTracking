//
//  ContentViewModel.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 14.11.2023.
//

import Foundation
import MapKit

class ContentViewModel: ObservableObject {
    
    @Published var trackManager: TrackManager
    
    init(trackManager: TrackManager) {
        self.trackManager = trackManager
    }
    
    func fetchTrack() async throws {
        try await trackManager.fetchTrack()
    }
}
