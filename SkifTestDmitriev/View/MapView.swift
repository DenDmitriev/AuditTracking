//
//  MapView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 19.11.2023.
//

import SwiftUI

struct MapView: View {
    
    @EnvironmentObject var trackManager: TrackManager
    
    @State var track: Track
    @State var isObserve: Bool = false
    @State var zoomLevel: Float = zoomDefaultLevel
    @State var isPlaying: Bool = false
    @State var showInfo: Bool = false
    @State var trackPlaySpeed: TrackPlaySpeed = .one
    @State var mapRouter: MapViewRouter = .empty
    @State var sliderMoving: Bool = false
    @State var trackContentFrame: CGRect = .zero
    
    private static let zoomObserveLevel: Float = 16
    private static let zoomDefaultLevel: Float = 10
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapViewControllerBridge(
                trackManager: trackManager,
                zoomLevel: $zoomLevel,
                track: $track,
                isPlaying: $isPlaying,
                playSpeed: $trackPlaySpeed,
                isObserve: $isObserve,
                mapRouter: $mapRouter,
                sliderMoving: $sliderMoving,
                onAnimationEnded: {
                    mapRouter = .empty
                },
                onZoomChanged: { zoomLevelCamera in
                    self.zoomLevel = zoomLevelCamera
                })
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
            
            ZoomControlView(zoom: $zoomLevel)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .frame(maxHeight: .infinity, alignment: .center)
                .offset(y: -20)
                .padding(16)
            
            ObserverView(isObserve: $isObserve)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .offset(y: -trackContentFrame.height)
                .padding(16)
                .disabled(isDisableControl())
            
            TrackContentView(
                track: $track,
                sliderMoving: $sliderMoving,
                isPlaying: $isPlaying,
                showInfo: $showInfo,
                trackPlaySpeed: $trackPlaySpeed
            )
            .padding(.bottom, 20)
            .background(
                VisualEffectView(effect: UIBlurEffect(style: .prominent))
            )
            .border(width: AppLayout.borderWidth, edges: [.top], color: AppColors.placeholder)
            .overlay(
                GeometryReader { geometryProxy in
                    let frame = geometryProxy.frame(in: .global)
                    Color.clear
                        .onAppear {
                            trackContentFrame = frame
                        }
                }
            )
        }
        .overlay(
            PopupView(isShowing: $showInfo) {
                SpeedLegendView()
            }
        )
        .ignoresSafeArea()
        .onAppear {
            mapRouter = .loadTrack
        }
        .onDisappear {
            isPlaying = false
            trackManager.closeTrack()
        }
    }
    
    
    private func isDisableControl() -> Bool {
        return false
    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(track: .placeholder)
            .environmentObject(TrackManager())
    }
}
