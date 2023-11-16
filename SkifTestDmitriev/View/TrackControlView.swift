//
//  TrackControlView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI

struct TrackControlView: View {
    
    @Binding var scale: TrackPlaySpeed
    @Binding var isPlay: Bool
    @Binding var showInfo: Bool
    
    let height: CGFloat = 44
    
    var body: some View {
        HStack {
            Button {
                scale = scale.next()
            } label: {
                Text(scale.rawValue.formatted() + "x")
                    .font(AppFonts.titleTwo)
                    .frame(width: height, height: height)
            }
            
            Spacer()

            Button {
                isPlay.toggle()
            } label: {
                Image(isPlay ? "pause" : "play")
                    .font(.title)
                    .frame(width: height, height: height)
            }
            
            Spacer()
            
            Button {
                showInfo.toggle()
            } label: {
                Image(systemName: showInfo ? "info.circle.fill" : "info.circle")
                    .font(AppFonts.titleTwo)
                    .frame(width: height, height: height)
            }
        }
    }
}

struct TrackControlView_Previews: PreviewProvider {
    static var previews: some View {
        TrackControlView(scale: .constant(.one), isPlay: .constant(true), showInfo: .constant(true))
    }
}
