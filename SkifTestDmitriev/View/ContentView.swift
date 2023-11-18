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
    @State var trackPlaySpeed: TrackPlaySpeed = .one
    @State var mapRouter: MapViewRouter = .empty
    @State var sliderMoving: Bool = false
    @State var trackContentFrame: CGRect = .zero
    
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
                    .offset(y: -20)
                    .padding(16)
            }
            .overlay {
                ObserverView(isObserve: $isObserve)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: -trackContentFrame.height)
                    .padding(16)
                    .disabled(isDisableControl())
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
            
            TrackContentView(
                sliderMoving: $sliderMoving,
                isPlaying: $isPlaying,
                showInfo: $showInfo,
                trackPlaySpeed: $trackPlaySpeed
            )
            .padding(.bottom, 20)
            .background(.regularMaterial)
            .border(width: AppLayout.borderWidth, edges: [.top], color: AppColors.placeholder)
            .overlay {
                GeometryReader { geometryProxy in
                    let frame = geometryProxy.frame(in: .global)
                    Color.clear
                        .onAppear {
                            trackContentFrame = frame
                        }
                }
            }
        }
        .overlay {
            LoadingView(isShowing: $trackManager.isLoading, text: $trackManager.message, progress: $trackManager.loadingProgress)
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
//            .environmentObject(trackManager)
            .environmentObject(TrackManager())
    }
}
