//
//  TrackManager.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 17.11.2023.
//

import SwiftUI

final class TrackManager: ObservableObject {
    
    @ObservedObject var trackStore = TrackStore()
    
    @Published var isLoading: Bool = false
    @Published var message: String?
    @Published var loadingProgress: LoadingProgress?
    @Published var progress: Int = 0
    
    var totalProgress: Int {
        let track = trackStore[trackStore.selectedTrack]
        return track.pointCount
    }
    
    lazy var speed: Binding<Double?> = .init(
        get: { [self] in
            let track = trackStore[trackStore.selectedTrack]
            guard let speed = track.locationPoints[self.progress].speed
            else { return 0 }
            let convertedSpeed = ((speed / 1000) * 60 * 60).rounded()
            return convertedSpeed
        },
        set: { _ in }
    )
    
    func fetchTracks() async throws {
        guard trackStore.tracks.isEmpty else { return }
        guard let url = URL(string: "https://dev5.skif.pro/coordinates.json") else { return }
//        guard let url = Bundle.main.url(forResource: "coordinateDebug", withExtension: "json") else { return }
        updateLoading(true)
        
        sendMessage("Загрузка пути...")
        let (data, _) = try await URLSession.shared.data(from: url)
       
        
        do {
            self.sendMessage("Чтение координат...")
            
            let decoder = JSONDecoder()
            let json = try decoder.decode([LocationPoint].self, from: data)
            
            self.sendMessage("Подготовка координат...")
            
            Self.buildTrackOperation(json: json) { loadingProgress in
                self.setLoadingProgress(progress: loadingProgress)
            } completion: { tracks in
                DispatchQueue.main.async {
                    self.trackStore.tracks = tracks
                    
                    if var loadingProgress = self.loadingProgress {
                        loadingProgress.value = loadingProgress.total
                        self.setLoadingProgress(progress: loadingProgress)
                    }
                    
                    self.updateLoading(false)
                }
            }
        }
        catch let error {
            self.sendMessage(error.localizedDescription)
        }
    }
    
    func closeTrack() {
        progress = 0
    }
    
    static func buildTrackOperation(
        json: [LocationPoint],
        handler: @escaping ((LoadingProgress) -> Void),
        completion: @escaping (([Track]) -> Void)
    ) {
        let operation = PrepareTrackOperation(json: json)
        operation.qualityOfService = .userInitiated
        operation.progress = { progress in
            handler(progress)
        }
        operation.completionBlock = {
            completion(operation.tracks)
        }
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        operationQueue.addOperation(operation)
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
