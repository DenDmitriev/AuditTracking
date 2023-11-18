//
//  TrackInfoView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI

struct TrackInfoView: View {
    
    @EnvironmentObject var trackManager: TrackManager
    @State var maxSpeed: Int?
    @State var distance: Int?
    @State var startAt: Date?
    @State var finishIn: Date?
    
    var body: some View {
        VStack(spacing: 4) {
            Text("Бензовоз")
                .font(AppFonts.titleOne)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                CustomLabel(systemName: "calendar", text: buildDateInterval())
                
                Spacer()
                
                CustomLabel(name: "distance", text: "\((distance ?? .zero).formatted(.number)) км")
                
                Spacer()
                
                CustomLabel(systemName: "speedometer", text: "До \((maxSpeed ?? .zero).formatted(.number))км/ч")
            }
            .font(AppFonts.regular)
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
        }
    }
    
    private func buildDateInterval() -> String {
        if let startAt, let finishIn {
            let text = dateFormatter.string(from: startAt) +
            " – " +
            dateFormatter.string(from: finishIn)
            
            return text
        } else {
            return ""
        }
    }
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd.MM.YYYY"
        return dateFormatter
    }
    
    private func isDisableControl() -> Bool {
        trackManager.track == nil
    }
}

struct TrackInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TrackInfoView()
            .environmentObject(TrackManager())
    }
}
