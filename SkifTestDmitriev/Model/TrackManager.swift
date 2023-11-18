//
//  TrackManager.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 17.11.2023.
//

import SwiftUI

final class TrackManager: ObservableObject {
    @Published var track: Track?
    @Published var isLoading: Bool = false
    @Published var progress: Int = 0
    @Published var total: Int = 1
    @Published var message: String?
    @Published var loadingProgress: LoadingProgress?
    
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
        updateLoading(true)
        
        sendMessage("Загрузка пути...")
        let (data, _) = try await URLSession.shared.data(from: url)
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                self.sendMessage("Чтение координат...")
                let decoder = JSONDecoder()
                let json = try decoder.decode([LocationPoint].self, from: data)
                
                self.sendMessage("Подготовка координат...")
                Track.buildTrackOperation(json: json) { loadingProgress in
                    self.setLoadingProgress(progress: loadingProgress)
                } completion: { track in
                    if let track {
                        DispatchQueue.main.async {
                            self.track = track
                            self.total = track.locationPoints.count - 1
                            self.updateLoading(false)
                        }
                    } else {
                        self.updateLoading(false)
                    }
                }
            }
            catch let error {
                self.sendMessage(error.localizedDescription)
            }
        }
    }
    
    private func setLoadingProgress(progress: LoadingProgress) {
        if self.loadingProgress == nil {
            DispatchQueue.main.async {
                self.loadingProgress = progress
            }
        } else {
            DispatchQueue.main.async {
                withAnimation {
                    self.loadingProgress?.value = progress.value
                    if self.loadingProgress?.total != progress.total {
                        self.loadingProgress?.total = progress.total
                    }
                }
            }
        }
    }
    
    private func sendMessage(_ text: String) {
        DispatchQueue.main.async {
            self.message = text
        }
    }
    
    private func updateLoading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            self.isLoading = isLoading
        }
    }
}
