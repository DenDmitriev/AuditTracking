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
            let years = trackManager.trackStore.years
            VStack {
                List(selection: selection) {
                    ForEach(years, id: \.self) { year in
                        let months = trackManager.trackStore.months(year: year)
                        ForEach(months, id: \.self) { month in
                            let title = Calendar.month(number: month)
                            let tracks = trackManager.trackStore.tracks(month: month, year: year)
                            Section {
                                ForEach(tracks) { track in
                                    NavigationLink {
                                        MapView(track: track)
                                    } label: {
                                        TrackRow(track: track)
                                    }
                                }
                            } header: {
                                Text(title + ", " + String(year))
                            } footer: {
                                Text(String(tracks.count.tracks()))
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("Маршруты")
        }
        .overlay(
            LoadingView(isShowing: $trackManager.isLoading, text: $trackManager.message, progress: $trackManager.loadingProgress)
        )
        .onAppear {
            Task {
                try await trackManager.fetchTracks()
            }
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
