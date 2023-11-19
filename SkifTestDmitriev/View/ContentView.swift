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
    
    private var selection: Binding<Track.ID?> {
        $trackManager.trackStore.selectedTrack
    }
    
    var body: some View {
        NavigationView {
            List(selection: selection) {
                ForEach(trackManager.trackStore.tracks) { track in
                    NavigationLink {
                        MapView(track: track)
                    } label: {
                        TrackRow(track: track)
                    }
                }
            }
            .overlay(
                LoadingView(isShowing: $trackManager.isLoading, text: $trackManager.message, progress: $trackManager.loadingProgress)
            )
            .onAppear {
                Task {
                    try await trackManager.fetchTracks()
                }
            }
            .navigationTitle("Маршруты")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let trackManager = TrackManager()
        ContentView()
            .environmentObject(trackManager)
    }
}
