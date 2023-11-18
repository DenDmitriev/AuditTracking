//
//  ContentView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI
import GoogleMaps

struct ContentView: View {
    
    @EnvironmentObject var trackManager: TrackManager
    @ObservedObject var viewModel: ContentViewModel
    
    @State var isObserve: Bool = false
    @State var zoomLevel: Float = zoomDefaultLevel
    @State var isPlaying: Bool = false
    @State var showInfo: Bool = false
    @State var maxSpeed: Int? = .zero
    @State var distance: Int? = .zero
    @State var startAt: Date?
    @State var finishIn: Date?
    @State var trackPlaySpeed: TrackPlaySpeed = .one
    @State var mapRouter: MapViewRouter = .empty
    @State var sliderMoving: Bool = false
    
    private static let zoomObserveLevel: Float = 18
    private static let zoomDefaultLevel: Float = 10
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapViewControllerBridge(
                zoomLevel: $zoomLevel,
                track: $trackManager.track,
                isPlaying: $isPlaying,
                progress: $trackManager.progress,
                playSpeed: $trackPlaySpeed,
                isObserve: $isObserve,
                mapRouter: $mapRouter,
                onAnimationEnded: {
                    mapRouter = .empty
                },
                onZoomChanged: { zoomLevelCamera in
                    self.zoomLevel = zoomLevelCamera
                })
            .overlay {
                ZoomControlView(zoom: $zoomLevel)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(16)
                    .offset(y: -20)
            }
            .onChange(of: isObserve) { isObserve in
                if isObserve {
                    zoomLevel = Self.zoomObserveLevel
                }
            }
            .onChange(of: zoomLevel) { newValue in
                mapRouter = .zoom
            }
            .onChange(of: isPlaying) { newValue in
                mapRouter = .player
            }
            .onChange(of: sliderMoving) { newValue in
                mapRouter = newValue ? .slider : .player
            }
            
            VStack(spacing: 0) {
                ObserverView(isObserve: $isObserve)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(16)
                
//                TrackSlider(
//                    value: Binding<Double>(
//                        get: { Double(trackManager.progress) },
//                        set: { value in trackManager.progress = Int(value) }
//                    ),
//                    total: Binding<Double>(
//                        get: { Double(trackManager.total) },
//                        set: { _ in }
//                    ),
//                    isEditing: $sliderMoving
//                )
                
                VStack(spacing: 8) {
                    TrackInfoView(
                        maxSpeed: $maxSpeed,
                        distance: $distance,
                        startAt: $startAt,
                        finishIn: $finishIn
                    )
                    
                    TrackSliderView(
                        value: $trackManager.progress,
                        total: $trackManager.total,
                        speed: trackManager.speed,
                        isEditing: $sliderMoving
                    )
                    .disabled(isDisableControl())
                    
                    TrackControlView(
                        trackSpeed: $trackPlaySpeed,
                        isPlay: $isPlaying,
                        showInfo: $showInfo
                    )
                    .disabled(isDisableControl())
                    
                }
                .padding(16)
                .padding(.bottom, 20)
                .background(.regularMaterial)
                .overlay {
                    VStack {
                        Rectangle()
                            .fill(AppColors.placeholder)
                            .frame(height: 0.25)
                        Spacer()
                    }
                }
            }
        }
        .overlay {
            LoadingView(isShowing: $trackManager.isProgress, text: "Подготовка пути")
        }
        .overlay {
            PopupView(isShowing: $showInfo) {
                SpeedLegendView()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                try await viewModel.fetchTrack()
            }
        }
        .onReceive(trackManager.$track) { newTrack in
            if let maxSpeed = newTrack?.maxSpeed {
                self.maxSpeed = Int(maxSpeed.rounded())
            }
            if let distance = newTrack?.distance {
                self.distance = Int(distance.rounded())
            }
            if let startAt = newTrack?.startAt {
                self.startAt = startAt
            }
            if let finishIn = newTrack?.finishIn {
                self.finishIn = finishIn
            }
            mapRouter = .loadTrack
        }
    }
    
    private func isDisableControl() -> Bool {
        trackManager.track == nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let trackManager = TrackManager()
        ContentView(viewModel: ContentViewModel(trackManager: trackManager))
            .environmentObject(TrackManager())
    }
}
