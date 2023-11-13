//
//  TrackProgressView.swift
//  SkifTestDmitriev
//
//  Created by Denis Dmitriev on 13.11.2023.
//

import SwiftUI

struct TrackProgressView: View {
    
    @Binding var trackProgress: Double
    @Binding var speed: Int?
    
    @State var progress: Double = .zero
    private let height: CGFloat = 3.0
    
    var body: some View {
        progressView
    }
    
    var progressView: some View {
        GeometryReader { geometryProxy in
            ZStack {
                RoundedRectangle(cornerRadius: height)
                    .foregroundColor(AppColors.placeholder)
                    .frame(width: geometryProxy.size.width, height: height)
                
                RoundedRectangle(cornerRadius: height)
                    .foregroundColor(.accentColor)
                    .frame(width: geometryProxy.size.width * trackProgress, height: height)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ZStack {
                    HStack {
                        Circle()
                            .fill(progress == .zero ? AppColors.placeholder : .accentColor)
                            .frame(width: height * 2)
                        Spacer()
                        Circle()
                            .fill(progress == 1 ? .accentColor : AppColors.placeholder)
                            .frame(width: height * 2)
                    }
                }
                
                bubble
                    .position(x: geometryProxy.size.width * progress, y: geometryProxy.size.height / 2)
                    .overlay {
                        if let speed {
                            Text(speed.formatted() + "км/ч")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.placeholder)
                                .position(x: geometryProxy.size.width * progress, y: geometryProxy.size.height / 2)
                                .offset(y: -25)
                        }
                        
                    }
                    .shadow(color: .black.opacity(0.08), radius: 6, y: 2)
            }
        }
        .frame(height: 50)
        .padding(.horizontal, 10)
        .onAppear {
            progress = prepareProgress(trackProgress)
        }
        .onChange(of: trackProgress) { newValue in
            withAnimation {
                progress = prepareProgress(newValue)
            }
        }
    }
    
    var bubble: some View {
        Circle()
            .strokeBorder(AppColors.background, lineWidth: 2)
            .background(Circle().foregroundColor(AppColors.accentColor))
            .frame(width: 20)
    }
    
    private func prepareProgress(_ value: Double) -> Double {
        switch value {
        case ..<0:
            return .zero
        case 0..<1:
            return value
        case 1...:
            return 1
        default:
            return .zero
        }
    }
}

struct TrackProgressView_Previews: PreviewProvider {
    static var previews: some View {
        TrackProgressView(trackProgress: .constant(0.3), speed: .constant(65))
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
