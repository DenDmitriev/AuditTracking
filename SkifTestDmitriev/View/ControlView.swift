//
//  ControlView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI

struct ControlView: View {
    
    @Binding var maxSpeed: Int?
    @Binding var distance: Int?
    @Binding var startAt: Date?
    @Binding var finishIn: Date?
    @State var trackProgress: Double = 0.3
    @State var scale: MapScale = .one
    @State var isPlay: Bool = false
    @Binding var showInfo: Bool
    
    var body: some View {
        VStack(spacing: 8) {
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
            
            TrackProgressView(trackProgress: $trackProgress, speed: $maxSpeed)
            
            TrackControlView(scale: $scale, isPlay: $isPlay, showInfo: $showInfo)
        }
        .padding(16)
    }
    
    private func buildDateInterval() -> String {
        if let startAt, let finishIn {
            let text = dateFormatter.string(from: startAt) +
            " – " +
            dateFormatter.string(from: finishIn)
            
            return text
        } else {
            return "N/A"
        }
    }
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd.MM.YYYY"
        return dateFormatter
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView(maxSpeed: .constant(95), distance: .constant(1246), startAt: .constant(Date.now - 24 * 12 * 3600), finishIn: .constant(Date.now), showInfo: .constant(false))
    }
}
