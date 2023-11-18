//
//  TrackInfoView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI

struct TrackInfoView: View {
    
    @EnvironmentObject var trackManager: TrackManager
    @Binding var maxSpeed: Int?
    @Binding var distance: Int?
    @Binding var startAt: Date?
    @Binding var finishIn: Date?
    
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
        TrackInfoView(
            maxSpeed: .constant(95),
            distance: .constant(1246),
            startAt: .constant(Date.now - 24 * 12 * 3600),
            finishIn: .constant(Date.now)
        )
        .environmentObject(TrackManager())
    }
}
