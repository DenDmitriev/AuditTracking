//
//  TrackInfoView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI

struct TrackInfoView: View {
    
    @Binding var track: Track
    @State var maxSpeed: Int?
    @State var distance: Int?
    @State var startAt: Date?
    @State var finishIn: Date?
    
    var body: some View {
        VStack(spacing: 4) {
            Text(track.name)
                .font(AppFonts.titleOne)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                CustomLabel(systemName: "calendar", text: buildDateInterval())
                
                Spacer()
                
                CustomLabel(name: "distance", text: "\((distance ?? .zero)) км")
                
                Spacer()
                
                CustomLabel(systemName: "speedometer", text: "До \((maxSpeed ?? .zero))км/ч")
            }
            .font(AppFonts.regular)
        }
        .onAppear {
            self.maxSpeed = Int(track.maxSpeed.rounded())
            self.distance = Int(track.distance.rounded())
            if let startAt = track.startAt {
                self.startAt = startAt
            }
            if let finishIn = track.finishIn {
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
        return false
    }
}

struct TrackInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TrackInfoView(track: .constant(.placeholder))
            .environmentObject(TrackManager())
    }
}
