//
//  TrackContentView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 18.11.2023.
//

import SwiftUI

struct TrackContentView: View {
    
    @EnvironmentObject var trackManager: TrackManager
    
    @Binding var track: Track
    @Binding var sliderMoving: Bool
    @Binding var isPlaying: Bool
    @Binding var showInfo: Bool
    @Binding var trackPlaySpeed: TrackPlaySpeed
    
    var body: some View {
        VStack(spacing: 2) {
            TrackInfoView(track: $track)
                .padding(.bottom, 10)
            
            TrackSliderView(
                value: $trackManager.progress,
                total: trackManager.totalProgress,
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
    }
    
    private func isDisableControl() -> Bool {
        return false
    }
}

struct TrackContentView_Previews: PreviewProvider {
    static var previews: some View {
        TrackContentView(
            track: .constant(.placeholder),
            sliderMoving: .constant(false),
            isPlaying: .constant(false),
            showInfo: .constant(false),
            trackPlaySpeed: .constant(.one)
        )
        .environmentObject(TrackManager())
    }
}
