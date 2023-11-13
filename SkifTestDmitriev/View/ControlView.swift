//
//  ControlView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI

struct ControlView: View {
    
    @State var speed: Int? = 65
    @State var trackProgress: Double = 0.3
    @State var scale: MapScale = .one
    @State var isPlay: Bool = false
    @State var showInfo: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Бензовоз")
                .font(AppFonts.titleOne)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Label {
                    Text("16.08.2023 — 16.08.2023")
                } icon: {
                    Image(systemName: "calendar")
                        .font(.body)
                        .foregroundColor(AppColors.icon)
                }
                
                Spacer()
                
                Label {
                    Text("10 км")
                } icon: {
                    Image("distance")
                        .font(.body)
                        .foregroundColor(AppColors.icon)
                }
                
                Spacer()
                
                Label {
                    Text("До 98км/ч")
                } icon: {
                    Image(systemName: "speedometer")
                        .font(.body)
                        .foregroundColor(AppColors.icon)
                }
            }
            .font(AppFonts.regular)
            
            TrackProgressView(trackProgress: $trackProgress, speed: $speed)
            
            TrackControlView(scale: $scale, isPlay: $isPlay, showInfo: $showInfo)
        }
        .padding(16)
//        .frame(maxHeight: 213)
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView()
    }
}
