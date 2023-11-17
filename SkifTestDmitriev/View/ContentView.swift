//
//  ContentView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI
import GoogleMaps

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    @State var isObserve: Bool = false
    @State var zoomLevel: Float = zoomDefaultLevel
    @State var track: Track?
    @State var isPlaying: Bool = false
    @State var showInfo: Bool = false
    @State var maxSpeed: Int? = .zero
    @State var distance: Int? = .zero
    @State var startAt: Date?
    @State var finishIn: Date?
    @State var progress: Int = .zero
    @State var trackPlaySpeed: TrackPlaySpeed = .one
    
    private static let zoomObserveLevel: Float = 18
    private static let zoomDefaultLevel: Float = 10
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapViewControllerBridge(
                zoomLevel: $zoomLevel,
                track: $track,
                isPlaying: $isPlaying,
                progress: $progress,
                speed: $trackPlaySpeed,
                isObserve: $isObserve,
                onAnimationEnded: {
                    
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
            
            VStack(spacing: 0) {
                ObserverView(isObserve: $isObserve)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(16)
                
                ControlView(
                    maxSpeed: $maxSpeed,
                    distance: $distance,
                    startAt: $startAt,
                    finishIn: $finishIn,
                    trackPlaySpeed: $trackPlaySpeed,
                    isPlaying: $isPlaying,
                    showInfo: $showInfo
                )
                    .background(.regularMaterial)
                    .overlay {
                        VStack {
                            Rectangle()
                                .fill(AppColors.placeholder)
                            .frame(height: 0.25)
                            Spacer()
                        }
                }
                    .padding(.bottom, 16)
            }
        }
        .overlay {
            LoadingView(isShowing: $viewModel.isProgress, text: "Подготовка пути")
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
        .onReceive(viewModel.$track) { newTrack in
            track = newTrack
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
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(viewModel: ContentViewModel())
//    }
//}
