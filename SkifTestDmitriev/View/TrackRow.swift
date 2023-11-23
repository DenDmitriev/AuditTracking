//
//  TrackRow.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 19.11.2023.
//

import SwiftUI

struct TrackRow: View {
    
    @State var track: Track
    
    let columns: [GridItem] = [
        .init(.flexible(), spacing: 16, alignment: .leading),
        .init(.flexible(), spacing: 16, alignment: .leading)
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text(track.name)
                    .font(AppFonts.titleTwo)
                
                Text(AppFormatters.dateFormatterDM.string(from: track.day))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: columns) {
                Text(distanceIcon + " \(distance) км")
                Text(speedIcon + " До \(maxSpeed) км/ч")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var distance: String {
        let distanceRounded = (track.distance * 10).rounded() / 10
        return "\(distanceRounded)"
    }
    
    private var maxSpeed: String {
        let speedRounded = track.maxSpeed.rounded()
        return "\(Int(speedRounded))"
    }
    
    private var distanceIcon: String {
        switch track.distance {
        case ..<1:
            return "🅿️"
        case 1..<1000:
            return "🚚"
        case 1000...:
            return "❓"
        default:
            return ""
        }
    }
    
    private var speedIcon: String {
        switch track.maxSpeed {
        case ..<70:
            return "🚥"
        case 70..<90:
            return "🛣️"
        case 90..<130:
            return "⚠️"
        case 130..<150:
            return "🚨"
        default:
            return "❓"
        }
    }
}

struct TrackRow_Previews: PreviewProvider {
    static var previews: some View {
        TrackRow(track: .placeholder)
    }
}
